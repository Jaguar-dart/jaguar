/// This library declares `Interceptor` class
library jaguar.http.interceptor;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

abstract class Interceptor {
  const Interceptor();

  FutureOr<void> call(Context ctx);
}

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
      for (RouteInterceptor before in ctx.beforeGlobal) {
        final maybeFuture = before(ctx);
        if (maybeFuture is Future) await maybeFuture;
      }
      {
        var beforeList = ctx.before;
        for (int i = 0; i < beforeList.length; i++) {
          final maybeFuture = ctx.before[i](ctx);
          if (maybeFuture is Future) await maybeFuture;
        }
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
        RouteInterceptor after = ctx.after[i];
        final maybeFuture = after(ctx);
        if (maybeFuture is Future) await maybeFuture;
      }
      for (int i = ctx.afterGlobal.length - 1; i >= 0; i--) {
        RouteInterceptor after = ctx.afterGlobal[i];
        final maybeFuture = after(ctx);
        if (maybeFuture is Future) await maybeFuture;
      }
    } catch (e, s) {
      Response resp;
      for (int i = ctx.onException.length - 1; i >= 0; i--) {
        try {
          dynamic maybeFuture = ctx.onException[i](ctx, e, s);
          if (maybeFuture != null) await maybeFuture;
        } catch (e) {
          if (e is Response) resp = e;
        }
      }
      if (resp != null) {
        ctx.response = resp;
        return;
      }
      rethrow;
    }
  }
}
