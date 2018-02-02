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
      return await Interceptor.chain(ctx, interceptors, handler, route);
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
class SimpleRouteChain implements RequestHandler {
  /// Static information about the route
  final RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteFunc handler;

  SimpleRouteChain(this.route, this.prefix, this.handler);

  /// Handles requests
  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    if (!route.match(
        ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams)) {
      return null;
    }

    var res = await handler(ctx);
    if (res is Response) {
      return res;
    } else {
      return new Response.fromRoute(res, route);
    }
  }
}

/// Prototype of route handler that returns [Response]
typedef Response<RespType> RouteHandlerRetResponse<RespType>(Context ctx);

/// Prototype of route handler that returns [Response] asynchronously
typedef Future<Response<RespType>> RouteHandlerRetResponseAsync<RespType>(
    Context ctx);

/// Prototype of route handler that returns [ResultType]
typedef ResultType RouteHandlerRetResult<ResultType extends Object>(
    Context ctx);

/// Prototype of route handler that returns [ResultType] asynchronously
typedef Future<ResultType> RouteHandlerRetResultAsync<
    ResultType extends Object>(Context ctx);

class _DummyClass {}

/// Prototype of route handler that returns [ResultType] asynchronously
typedef _DummyClass _Dummy<ResultType extends Object>(Context ctx);

/// Prototype of route handler that returns [ResultType] asynchronously
typedef Future<_DummyClass> _DummyWithFuture<ResultType extends Object>(
    Context ctx);

RequestHandler simpleHandler(
    RouteBase route, String prefix, final RouteFunc handler) {
  if (handler is! _Dummy && handler is! _DummyWithFuture) {
    if (handler is RouteHandlerRetResponseAsync) {
      return new RetResponseAsyncHandler(route, prefix, handler);
    } else if (handler is RouteHandlerRetResponse) {
      return new RetResponseHandler(route, prefix, handler);
    } else if (handler is RouteHandlerRetResultAsync) {
      return new RetResultAsyncHandler(route, prefix, handler);
    } else if (handler is RouteHandlerRetResult) {
      return new RetResultHandler(route, prefix, handler);
    }
  }
  return new SimpleRouteChain(route, prefix, handler);
}

class RetResponseHandler extends RequestHandler {
  /// Static information about the route
  final RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteHandlerRetResponse handler;

  RetResponseHandler(this.route, this.prefix, this.handler);

  /// Handles requests
  Response handleRequest(Context ctx, {String prefix: ''}) {
    if (!route.match(
        ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams)) {
      return null;
    }
    return handler(ctx);
  }
}

class RetResponseAsyncHandler extends RequestHandler {
  /// Static information about the route
  final RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteHandlerRetResponseAsync handler;

  RetResponseAsyncHandler(this.route, this.prefix, this.handler);

  /// Handles requests
  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    if (!route.match(
        ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams)) {
      return null;
    }
    return handler(ctx);
  }
}

class RetResultAsyncHandler extends RequestHandler {
  /// Static information about the route
  final RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteHandlerRetResultAsync handler;

  RetResultAsyncHandler(this.route, this.prefix, this.handler);

  /// Handles requests
  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    if (!route.match(
        ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams)) {
      return null;
    }
    return new Response.fromRoute(await handler(ctx), route);
  }
}

class RetResultHandler extends RequestHandler {
  /// Static information about the route
  final RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteHandlerRetResult handler;

  RetResultHandler(this.route, this.prefix, this.handler);

  /// Handles requests
  Response handleRequest(Context ctx, {String prefix: ''}) {
    if (!route.match(
        ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams)) {
      return null;
    }
    return new Response.fromRoute(handler(ctx), route);
  }
}
