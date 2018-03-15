// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar.http.reflect;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'dart:mirrors';
import 'dart:collection';

/// Composing routes are parsed by reflecting the provided [_api]. Alternative
/// is to to source generate.
class ReflectedApi implements RequestHandler {
  /// The api instance being reflected
  final dynamic _api;

  /// Routes parsed from [_api]
  final _routes = <RequestHandler>[];

  /// The composing routes.
  ///
  /// Publicly exposes an immutable version of [_routes]
  UnmodifiableListView<RequestHandler> get routes =>
      new UnmodifiableListView<RequestHandler>(_routes);

  /// Constructs a
  ReflectedApi(this._api) {
    _parseApi();
  }

  /// Handles requests
  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    for (RequestHandler route in _routes) {
      Response response = await route.handleRequest(ctx, prefix: prefix);
      if (response is Response) {
        return response;
      }
    }

    return null;
  }

  void _parseApi() {
    final InstanceMirror im = reflect(_api);
    final List<Api> apis = im.type.metadata
        .map((InstanceMirror aim) => aim.reflectee)
        .where((dynamic ref) => ref is Api)
        .toList() as List<Api>;
    if (apis.length == 0) {
      throw new Exception('Handler is not decorated with Api!');
    }

    final List<InterceptorCreator> wrappers =
        _detectWrappers(im, im.type.metadata);

    final List<ExceptionHandler> exceptionHandlers = im.type.metadata
        .where((InstanceMirror annot) => annot.reflectee is ExceptionHandler)
        .map((InstanceMirror annot) => annot.reflectee)
        .toList() as List<ExceptionHandler>;

    _parse(im, apis.first.path,
        topWrapper: wrappers, topExceptionHandlers: exceptionHandlers);
  }

  void _parse(InstanceMirror im, String pathPrefix,
      {List<InterceptorCreator> topWrapper: const [],
      List<ExceptionHandler> topExceptionHandlers: const []}) {
    im.type.declarations.forEach((Symbol s, DeclarationMirror decl) {
      if (decl.isPrivate) return;

      // Collect IncludeApi
      if (decl is VariableMirror) {
        final List<IncludeApi> groups = decl.metadata
            .where((InstanceMirror annot) => annot.reflectee is IncludeApi)
            .map((InstanceMirror annot) => annot.reflectee)
            .toList() as List<IncludeApi>;

        if (groups.length == 0) return;

        if (!decl.isFinal) {
          throw new Exception('IncludeApi must be final!');
        }

        final InstanceMirror gim = im.getField(s);
        if (gim.reflectee == null) {
          throw new Exception('Group cannot be null!');
        }

        List<Api> rg = gim.type.metadata
            .where((InstanceMirror annot) => annot.reflectee is Api)
            .map((InstanceMirror annot) => annot.reflectee)
            .toList() as List<Api>;

        if (rg.length == 0) {
          throw new Exception('Included API must be annotated with Api!');
        }

        final List<InterceptorCreator> wrappers =
            _detectWrappers(gim, gim.type.metadata);

        _parse(gim, pathPrefix + groups.first.path + rg.first.path,
            topWrapper: wrappers);
      }

      //Collect routes

      if (decl is! MethodMirror) return;

      final List<RouteBase> routes = decl.metadata
          .where((InstanceMirror annot) => annot.reflectee is RouteBase)
          .map((InstanceMirror annot) => annot.reflectee)
          .toList() as List<RouteBase>;
      if (routes.length == 0) return;

      final List<InterceptorCreator> wrappers =
          _detectWrappers(im, decl.metadata);

      wrappers.insertAll(0, topWrapper);

      // Collect exception handlers

      List<ExceptionHandler> exceptionHandlers = decl.metadata
          .where((InstanceMirror annot) => annot.reflectee is ExceptionHandler)
          .map((InstanceMirror annot) => annot.reflectee)
          .toList() as List<ExceptionHandler>;
      exceptionHandlers.insertAll(0, topExceptionHandlers);

      InstanceMirror method = im.getField(s);

      routes
          .map((RouteBase route) => _reflectClass(method.reflectee, route,
              pathPrefix, wrappers, im, exceptionHandlers))
          .forEach(_routes.add);
    });
  }

  /// Detects interceptor wrappers on a method or function
  List<InterceptorCreator> _detectWrappers(
      InstanceMirror im, List<InstanceMirror> annots) {
    final wrappers = <InterceptorCreator>[];

    for (InstanceMirror annot in annots) {
      dynamic ref = annot.reflectee;
      if (ref is WrapOne) {
        if (ref.interceptor is Symbol) {
          wrappers.add(
              (Context ctx) => im.invoke(ref.interceptor, [ctx]).reflectee);
        } else {
          wrappers.add(ref.interceptor);
        }
      } else if (ref is Wrap) {
        for (dynamic ic in ref.interceptors) {
          if (ic is Symbol) {
            wrappers.add((Context ctx) => im.invoke(ic, [ctx]).reflectee);
          } else {
            wrappers.add(ic);
          }
        }
      }
    }

    return wrappers;
  }
}

/// Builds the route for class based routes
RequestHandler _reflectClass(
    RouteFunc handler,
    RouteBase route,
    String prefix,
    List<InterceptorCreator> wraps,
    InstanceMirror groupIm,
    List<ExceptionHandler> exceptionHandlers) {
  if (wraps.length == 0 && exceptionHandlers.length == 0) {
    return simpleHandler(route, prefix, handler);
  }

  return new RouteChain(route, prefix, handler, wraps, exceptionHandlers);
}
