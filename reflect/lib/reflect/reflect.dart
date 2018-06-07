// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar.http.reflect;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'dart:mirrors';
import 'dart:collection';

/// Composing routes are parsed by reflecting the provided [_api]. Alternative
/// is to to source generate.
class ReflectedController implements RequestHandler {
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
  ReflectedController(this._api) {
    _parseController();
  }

  /// Handles requests
  Future<void> handleRequest(Context ctx) async {
    for (RequestHandler route in _routes) {
      await route.handleRequest(ctx);
      if (ctx.response is Response) return null;
    }
    return null;
  }

  void _parseController() {
    final InstanceMirror im = reflect(_api);

    Controller api = _getAnnotation<Controller>(im.type.metadata);
    if (api == null)
      throw new Exception(
          'Handler is not decorated with Controller annotation!');

    final List<RouteInterceptor> before = _detectBefore(im, im.type.metadata);
    final List<RouteInterceptor> after = _detectAfter(im, im.type.metadata);
    final List<ExceptionHandler> onException =
        _detectExceptionHandlers(im, im.type.metadata);

    _parse(im, api.path,
        topBefore: before, topAfter: after, topExceptionHandlers: onException);
  }

  void _parse(InstanceMirror im, String pathPrefix,
      {List<RouteInterceptor> topBefore: const [],
      List<RouteInterceptor> topAfter: const [],
      List<ExceptionHandler> topExceptionHandlers: const []}) {
    for (DeclarationMirror decl in im.type.declarations.values) {
      if (decl.isPrivate) continue;

      // Collect IncludeApi
      if (decl is VariableMirror) {
        _parseGroup(pathPrefix, decl, im.getField(decl.simpleName));
        continue;
      }

      // Collect routes
      if (decl is MethodMirror) {
        _parseRoute(
            im, pathPrefix, decl, topBefore, topAfter, topExceptionHandlers);
        continue;
      }
    }
  }

  void _parseGroup(String pathPrefix, VariableMirror decl, InstanceMirror gim) {
    final IncludeHandler group = _getAnnotation<IncludeHandler>(decl.metadata);

    if (group == null) return;

    if (!decl.isFinal) throw new Exception('IncludeApi must be final!');

    if (gim.reflectee == null) throw new Exception('Group cannot be null!');

    Controller rg = _getAnnotation<Controller>(gim.type.metadata);

    if (rg == null)
      throw new Exception('Included API must be annotated with Api!');

    final List<RouteInterceptor> before = _detectBefore(gim, decl.metadata)
      ..addAll(_detectBefore(gim, gim.type.metadata));
    final List<RouteInterceptor> after = _detectAfter(gim, decl.metadata)
      ..addAll(_detectAfter(gim, gim.type.metadata));
    final List<ExceptionHandler> onException =
        _detectExceptionHandlers(gim, decl.metadata)
          ..addAll(_detectExceptionHandlers(gim, gim.type.metadata));

    _parse(gim, pathPrefix + group.path + rg.path,
        topBefore: before, topAfter: after, topExceptionHandlers: onException);
    return;
  }

  void _parseRoute(
      InstanceMirror im,
      String pathPrefix,
      MethodMirror decl,
      List<RouteInterceptor> topBefore,
      List<RouteInterceptor> topAfter,
      List<ExceptionHandler> topExceptionHandlers) {
    final List<HttpMethod> routes = decl.metadata
        .where((InstanceMirror annot) => annot.reflectee is HttpMethod)
        .map((InstanceMirror annot) => annot.reflectee)
        .toList().cast<HttpMethod>();
    if (routes.length == 0) return;

    final List<RouteInterceptor> before = topBefore.toList()
      ..addAll(_detectBefore(im, decl.metadata));
    final List<RouteInterceptor> after = topAfter.toList()
      ..addAll(_detectAfter(im, decl.metadata));
    final List<ExceptionHandler> onException = topExceptionHandlers.toList()
      ..addAll(_detectExceptionHandlers(im, decl.metadata));

    InstanceMirror method = im.getField(decl.simpleName);

    for (HttpMethod route in routes) {
      final cloned = route.cloneWith(path: pathPrefix + route.path);
      final r = new Route.fromInfo(cloned, method.reflectee,
          before: before, after: after, onException: onException);
      _routes.add(r);
    }
  }

  /// Detects interceptor wrappers on a method or function
  List<RouteInterceptor> _detectBefore(
      InstanceMirror im, List<InstanceMirror> annots) {
    final wrappers = <RouteInterceptor>[];

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
  List<RouteInterceptor> _detectAfter(InstanceMirror im, List<InstanceMirror> annots) {
    final wrappers = <RouteInterceptor>[];

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
