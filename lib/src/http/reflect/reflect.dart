library jaguar.http.reflect;

import 'dart:async';
import 'package:jaguar/jaguar.dart' as j;
import 'dart:mirrors';

part 'route.dart';

class JaguarReflected implements j.RequestHandler {
  final dynamic _handler;

  final _routes = <ReflectedRoute>[];

  JaguarReflected(this._handler) {
    _parseApi();
  }

  Future<j.Response> handleRequest(j.Context ctx, {String prefix: ''}) async {
    for (ReflectedRoute route in _routes) {
      j.Response response =
          await route.handleRequest(ctx, prefix: prefix + route.prefix);
      if (response is j.Response) {
        return response;
      }
    }

    return null;
  }

  void _parseApi() {
    final InstanceMirror im = reflect(_handler);
    final List<j.Api> apis = im.type.metadata
        .map((InstanceMirror aim) => aim.reflectee)
        .where((dynamic ref) => ref is j.Api)
        .toList() as List<j.Api>;
    if (apis.length == 0) {
      throw new Exception('Handler is not decorated with Api!');
    }

    final List<Symbol> wrappers = _detectWrappers(im.type.metadata);

    final List<j.ExceptionHandler> exceptionHandlers = im.type.metadata
        .where((InstanceMirror annot) => annot.reflectee is j.ExceptionHandler)
        .map((InstanceMirror annot) => annot.reflectee)
        .toList() as List<j.ExceptionHandler>;

    _parse(im, apis.first.path,
        topWrapper: wrappers, topExceptionHandlers: exceptionHandlers);
  }

  void _parse(InstanceMirror im, String pathPrefix,
      {List<Symbol> topWrapper: const [],
      List<j.ExceptionHandler> topExceptionHandlers: const []}) {
    im.type.declarations.forEach((Symbol s, DeclarationMirror decl) {
      if (decl.isPrivate) return;

      // Collect IncludeApi
      if (decl is VariableMirror) {
        final List<j.IncludeApi> groups = decl.metadata
            .where((InstanceMirror annot) => annot.reflectee is j.IncludeApi)
            .map((InstanceMirror annot) => annot.reflectee)
            .toList() as List<j.IncludeApi>;

        if (groups.length == 0) return;

        if (!decl.isFinal) {
          throw new Exception('IncludeApi must be final!');
        }

        final InstanceMirror gim = im.getField(s);
        if (gim.reflectee == null) {
          throw new Exception('Group cannot be null!');
        }

        List<j.Api> rg = gim.type.metadata
            .where((InstanceMirror annot) => annot.reflectee is j.Api)
            .map((InstanceMirror annot) => annot.reflectee)
            .toList() as List<j.Api>;

        if (rg.length == 0) {
          throw new Exception('Included API must be annotated with Api!');
        }

        final List<Symbol> wrappers = _detectWrappers(gim.type.metadata);

        _parse(gim, pathPrefix + groups.first.path + rg.first.path,
            topWrapper: wrappers);
      }

      //Collect routes

      if (decl is! MethodMirror) return;

      final List<j.RouteBase> routes = decl.metadata
          .where((InstanceMirror annot) => annot.reflectee is j.RouteBase)
          .map((InstanceMirror annot) => annot.reflectee)
          .toList() as List<j.RouteBase>;
      if (routes.length == 0) return;

      final List<Symbol> wrappers = _detectWrappers(decl.metadata);

      wrappers.insertAll(0, topWrapper);

      // Collect exception handlers

      List<j.ExceptionHandler> exceptionHandlers = decl.metadata
          .where(
              (InstanceMirror annot) => annot.reflectee is j.ExceptionHandler)
          .map((InstanceMirror annot) => annot.reflectee)
          .toList() as List<j.ExceptionHandler>;
      exceptionHandlers.insertAll(0, topExceptionHandlers);

      InstanceMirror method = im.getField(s);

      routes
          .map((j.RouteBase route) => new ReflectedRoute.buildForClass(
              method.reflectee,
              route,
              pathPrefix,
              wrappers,
              im,
              exceptionHandlers))
          .forEach(_routes.add);
    });
  }
}

JaguarReflected reflectJaguar(Object routeGroup) =>
    new JaguarReflected(routeGroup);

List<Symbol> _detectWrappers(List<InstanceMirror> annots) {
  final wrappers = <Symbol>[];

  for (InstanceMirror annot in annots) {
    dynamic ref = annot.reflectee;
    if (ref is j.WrapOne) {
      wrappers.add(ref.interceptor);
    } else if (ref is j.Wrap) {
      wrappers.addAll(ref.interceptors);
    }
  }

  return wrappers;
}
