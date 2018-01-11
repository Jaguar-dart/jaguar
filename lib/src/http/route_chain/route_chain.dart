library jaguar.http.route_chain;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// Encapsulates the whole chain of a route including the [handler],
/// [interceptors] and [exceptionHandlers].
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
        final Response resp = await handler.onRouteException(ctx, e, s);
        if (resp is Response) {
          return resp;
        }
      }
      rethrow;
    }
  }
}

/// Encapsulates the whole chain of a route including the [handler]. Does not
/// support interceptors and exception handlers.
class RouteChainSimple implements RequestHandler {
  /// Static information about the route
  final RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteFunc handler;

  RouteChainSimple(this.route, this.prefix, this.handler);

  /// Handles requests
  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    if (!route.match(
        ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams)) {
      return null;
    }

    final res = await handler(ctx);
    if (res is Response) {
      return res;
    } else if (res != null) {
      final resp = new Response(res,
          headers: route.headers, statusCode: route.statusCode);
      resp.headers.mimeType = route.mimeType;
      resp.headers.charset = route.charset;
      return resp;
    }
    return null;
  }
}
