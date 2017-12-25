library jaguar.http.route_chain;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'dart:mirrors';

/// Encapsulates the whole chain of a route including the [handler], [interceptors]
/// and [exceptionHandlers].
class RouteChain implements RequestHandler {
  /// Static information about the route
  final RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteFunc handler;

  /// RouteWrappers to wrap the route with interceptors
  final List<InterceptorCreator> interceptors;

  final List<ExceptionHandler> exceptionHandlers;

  RouteChain(this.route, this.prefix, this.handler, this.interceptors,
      this.exceptionHandlers);

  /// Handles requests
  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    try {
      if (!route.match(
          ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams)) {
        return null;
      }
      ctx.addInterceptors(interceptors);
      return await Interceptor.chain(ctx, handler, route);
    } catch (e, s) {
      for (ExceptionHandler handler in exceptionHandlers) {
        InstanceMirror im = reflect(e);
        if (im.type.isAssignableTo(reflectType(handler.exceptionType()))) {
          return handler.onRouteException(ctx, e, s);
        }
      }
      rethrow;
    }
  }

  /// Builds the route for class based routes
  factory RouteChain.reflectClass(
      RouteFunc handler,
      RouteBase jRoute,
      String prefix,
      List<Symbol> wraps,
      InstanceMirror groupIm,
      List<ExceptionHandler> exceptionHandlers) {
    final interceptors = <InterceptorCreator>[];

    for (final Symbol wrap in wraps) {
      MethodMirror mm = _checkCreator(groupIm.type, wrap);
      if (mm == null)
        throw new Exception("Interceptor creater " +
            MirrorSystem.getName(wrap) +
            " not found!");
      interceptors.add((Context ctx) => groupIm.invoke(wrap, [ctx]).reflectee);
    }

    return new RouteChain(
        jRoute, prefix, handler, interceptors, exceptionHandlers);
  }
}

MethodMirror _checkCreator(ClassMirror cm, Symbol method) {
  DeclarationMirror dm = cm.declarations[method];

  if (dm != null) {
    if (dm is MethodMirror) return dm;
    throw new Exception("Interceptor creater must be method!");
  }

  dm = _checkCreator(cm.superclass, method);

  if (dm != null) {
    if (dm is MethodMirror) return dm;
    throw new Exception("Interceptor creater must be method!");
  }

  for (ClassMirror scm in cm.superinterfaces) {
    dm = _checkCreator(scm, method);

    if (dm != null) {
      if (dm is MethodMirror) return dm;
      throw new Exception("Interceptor creater must be method!");
    }
  }

  return null;
}