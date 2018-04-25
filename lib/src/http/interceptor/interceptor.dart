/// This library declares `Interceptor` class
library jaguar.http.interceptor;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// Signature of interceptor creator method
typedef Interceptor InterceptorCreator(Context ctx);

/// [onException] is executed if there is an exception in the route chain.
/// This can be used to clean up resources used by the interceptor.
abstract class FullInterceptor<OutputType, ResponseType, InResponseType>
    extends Interceptor {
  /// Shall be called after execution of route handler
  /// \param ctx    Request context
  /// \param inResp Incoming response
  /// \returns      Transformed response
  FutureOr<Response<ResponseType>> after(
      Context ctx, Response<InResponseType> inResp);
}

/// An interceptor wraps a route and performs an action before and
/// after the route handler.
///
/// [before] is the code that is executed before route handler
abstract class Interceptor {
  /// Identifies an interceptor in the interceptor chain
  String get id => null;

  const Interceptor();

  /// Shall be called before execution of route handler
  FutureOr<void> before(Context ctx);

  /// Executes a route chain
  static Future<Response<RespType>> chain<RespType, RouteRespType>(
      final Context ctx,
      final List<InterceptorCreator> interceptorCreators,
      final RouteFunc<RouteRespType> routeHandler,
      final RouteBase routeInfo) async {
    Response resp;

    final afterList = <FullInterceptor>[];

    try {
      for (InterceptorCreator creator in interceptorCreators) {
        final Interceptor interceptor = creator(ctx);
        await interceptor.before(ctx);
        if (interceptor is FullInterceptor) afterList.add(interceptor);
      }

      {
        var res = await routeHandler(ctx);
        print(res);
        if (res is Response) {
          resp = res;
        } else {
          resp = new Response<RespType>.fromRoute(res, routeInfo);
        }
      }

      while (afterList.length > 0) {
        resp = await afterList.last.after(ctx, resp);
        afterList.removeLast();
      }
    } catch (e) {
      for (OnException onException in ctx.onException.reversed) {
        await onException(ctx);
      }
      rethrow;
    }

    return resp as Response<RespType>;
  }
}
