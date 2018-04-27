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
  Future<void> handleRequest(Context ctx, {String prefix: ''}) async {
    for (RequestHandler route in _routes) {
      await route.handleRequest(ctx, prefix: prefix);
      if (ctx.response is Response) return null;
    }
    return null;
  }

  void _parseApi() {
    final InstanceMirror im = reflect(_api);

    Api api = _getAnnotation<Api>(im.type.metadata);
    if (api == null) throw new Exception('Handler is not decorated with Api!');

    final List<RouteFunc> before = _detectBefore(im, im.type.metadata);
    final List<RouteFunc> after = _detectAfter(im, im.type.metadata);
    final List<ExceptionHandler> onException =
        _detectExceptionHandlers(im, im.type.metadata);

    _parse(im, api.path,
        topBefore: before, topAfter: after, topExceptionHandlers: onException);
  }

  void _parse(InstanceMirror im, String pathPrefix,
      {List<RouteFunc> topBefore: const [],
      List<RouteFunc> topAfter: const [],
      List<ExceptionHandler> topExceptionHandlers: const []}) {
    im.type.declarations.forEach((Symbol s, DeclarationMirror decl) {
      if (decl.isPrivate) return;

      // Collect IncludeApi
      if (decl is VariableMirror) {
        _parseGroup(pathPrefix, decl, im.getField(s));
        return;
      }

      // Collect routes

      if (decl is MethodMirror) {
        _parseRoute(
            im, pathPrefix, decl, topBefore, topAfter, topExceptionHandlers);
        return;
      }
    });
  }

  void _parseGroup(String pathPrefix, VariableMirror decl, InstanceMirror gim) {
    final IncludeApi group = _getAnnotation<IncludeApi>(decl.metadata);

    if (group == null) return;

    if (!decl.isFinal) throw new Exception('IncludeApi must be final!');

    if (gim.reflectee == null) throw new Exception('Group cannot be null!');

    Api rg = _getAnnotation<Api>(gim.type.metadata);

    if (rg == null)
      throw new Exception('Included API must be annotated with Api!');

    final List<RouteFunc> before = _detectBefore(gim, gim.type.metadata);
    final List<RouteFunc> after = _detectAfter(gim, gim.type.metadata);
    final List<ExceptionHandler> onException =
        _detectExceptionHandlers(gim, gim.type.metadata);

    _parse(gim, pathPrefix + group.path + rg.path,
        topBefore: before, topAfter: after, topExceptionHandlers: onException);
    return;
  }

  void _parseRoute(
      InstanceMirror im,
      String pathPrefix,
      MethodMirror decl,
      List<RouteFunc> topBefore,
      List<RouteFunc> topAfter,
      List<ExceptionHandler> topExceptionHandlers) {
    final List<Route> routes = decl.metadata
        .where((InstanceMirror annot) => annot.reflectee is Route)
        .map((InstanceMirror annot) => annot.reflectee)
        .toList() as List<Route>;
    if (routes.length == 0) return;

    final List<RouteFunc> before = _detectBefore(im, decl.metadata);
    final List<RouteFunc> after = _detectAfter(im, decl.metadata);
    final List<ExceptionHandler> onException =
        _detectExceptionHandlers(im, decl.metadata);

    before.insertAll(0, topBefore);
    after.insertAll(0, topAfter);
    onException.insertAll(0, topExceptionHandlers);

    InstanceMirror method = im.getField(decl.simpleName);

    routes
        .map((Route route) => new RouteChain(
            route, pathPrefix, method.reflectee,
            before: before, after: after, onException: onException))
        .forEach(_routes.add);
  }

  /// Detects interceptor wrappers on a method or function
  List<RouteFunc> _detectBefore(
      InstanceMirror im, List<InstanceMirror> annots) {
    final wrappers = <RouteFunc>[];

    for (InstanceMirror annot in annots) {
      dynamic ref = annot.reflectee;
      if (ref is Intercept) {
        for (dynamic ic in ref.before) {
          if (ic is Symbol) {
            wrappers.add((Context ctx) => im.invoke(ic, [ctx]));
          } else {
            wrappers.add(ic);
          }
        }
      }
    }

    return wrappers;
  }

  /// Detects interceptor wrappers on a method or function
  List<RouteFunc> _detectAfter(InstanceMirror im, List<InstanceMirror> annots) {
    final wrappers = <RouteFunc>[];

    for (InstanceMirror annot in annots) {
      dynamic ref = annot.reflectee;
      if (ref is Intercept) {
        for (dynamic ic in ref.after) {
          if (ic is Symbol) {
            wrappers.add((Context ctx) => im.invoke(ic, [ctx]));
          } else {
            wrappers.add(ic);
          }
        }
      } else if (ref is After) {
        for (dynamic ic in ref.after) {
          if (ic is Symbol) {
            wrappers.add((Context ctx) => im.invoke(ic, [ctx]));
          } else {
            wrappers.add(ic);
          }
        }
      }
    }

    return wrappers;
  }

  /// Detects interceptor wrappers on a method or function
  List<ExceptionHandler> _detectExceptionHandlers(
      InstanceMirror im, List<InstanceMirror> annots) {
    final wrappers = <ExceptionHandler>[];

    for (InstanceMirror annot in annots) {
      dynamic ref = annot.reflectee;
      if (ref is Intercept) {
        for (dynamic ic in ref.onException) {
          if (ic is Symbol) {
            wrappers.add(
                (Context ctx, e, StackTrace s) => im.invoke(ic, [ctx, e, s]));
          } else {
            wrappers.add(ic);
          }
        }
      } else if (ref is OnException) {
        for (dynamic ic in ref.onException) {
          if (ic is Symbol) {
            wrappers.add(
                (Context ctx, e, StackTrace s) => im.invoke(ic, [ctx, e, s]));
          } else {
            wrappers.add(ic);
          }
        }
      }
    }

    return wrappers;
  }
}

T _getAnnotation<T>(List<InstanceMirror> annots) => annots
    .map((InstanceMirror aim) => aim.reflectee)
    .firstWhere((ref) => ref is T, orElse: () => null);
