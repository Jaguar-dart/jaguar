library jaguar.http.route_chain;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// Encapsulates the whole chain of a route including the [handler],
/// [interceptors] and [exceptionHandlers].
class RouteChain implements RequestHandler {
  /// Static information about the route
  final Route route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final RouteHandler handler;

  final List<RouteFunc> before;

  final List<RouteFunc> after;

  final List<ExceptionHandler> onException;

  RouteChain(this.route, this.prefix, this.handler,
      {this.before: const [],
      this.after: const [],
      this.onException: const []});

  /// Handles requests
  Future<void> handleRequest(Context ctx, {String prefix: ''}) async {
    try {
      if (!route.match(
          ctx.path, ctx.method, prefix + this.prefix, ctx.pathParams))
        return null;
      ctx.before.addAll(before);
      ctx.after.addAll(after);
      ctx.onException.addAll(onException);
      await Do.chain(ctx, handler, route);
      return null;
    } catch (e, s) {
      for (int i = ctx.onException.length - 1; i >= 0; i++) {
        await ctx.onException[i](ctx, e, s);
      }
      rethrow;
    }
  }
}
