/// This library declares `Interceptor` class
library jaguar.http.interceptor;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

/*
/// An interceptor wraps a route and performs an action before and
/// after the route handler.
///
/// [before] is the code that is executed before route handler
abstract class Interceptor {
  const Interceptor();

  /// Shall be called before execution of route handler
  FutureOr<void> before(Context ctx);

  /// Shall be called after execution of route handler
  /// \param ctx    Request context
  /// \param inResp Incoming response
  /// \returns      Transformed response
  FutureOr<void> after(Context ctx);
}
 */

abstract class Do {
  /// Executes a route chain
  static Future<void> chain<RespType, RouteRespType>(
      final Context ctx,
      final RouteHandler<RouteRespType> routeHandler,
      final HttpMethod routeInfo) async {
    try {
      for (RouteFunc before in ctx.beforeGlobal) {
        final res = before(ctx);
        if (res is Future) await res;
      }
      for (RouteFunc before in ctx.before) {
        final res = before(ctx);
        if (res is Future) await res;
      }

      {
        dynamic res = routeHandler(ctx);
        if (res is Future) res = await res;
        if (ctx.response == null) {
          if (res is Response)
            ctx.response = res;
          else
            ctx.response = new Response<RespType>.fromRoute(res, routeInfo);
        }
      }

      for (int i = ctx.after.length - 1; i >= 0; i--) {
        RouteFunc after = ctx.after[i];
        final res = after(ctx);
        if (res is Future) await res;
      }
      for (int i = ctx.afterGlobal.length - 1; i >= 0; i--) {
        RouteFunc after = ctx.afterGlobal[i];
        final res = after(ctx);
        if (res is Future) await res;
      }
    } catch (e, s) {
      for (int i = ctx.onException.length - 1; i >= 0; i--) {
        await ctx.onException[i](ctx, e, s);
      }
      rethrow;
    }
  }
}
