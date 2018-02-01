/// This library declares `Interceptor` class
library jaguar.http.interceptor;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// Signature of interceptor creator method
typedef Interceptor<OutputType> InterceptorCreator<OutputType>(Context ctx);

/// [onException] is executed if there is an exception in the route chain.
/// This can be used to clean up resources used by the interceptor.
abstract class FullInterceptor<OutputType, ResponseType, InResponseType>
    extends Interceptor<OutputType> {
  /// Shall be called after execution of route handler
  /// \param ctx    Request context
  /// \param inResp Incoming response
  /// \returns      Transformed response
  FutureOr<Response<ResponseType>> after(
      Context ctx, Response<InResponseType> inResp);

  /// Shall be called if there is an exception in the route chain.
  /// This can be used to clean up resources used by the interceptor.
  FutureOr<Null> onException() => null;
}

/// An interceptor wraps a route and performs an action before and
/// after the route handler.
///
/// [before] is the code that is executed before route handler
abstract class Interceptor<OutputType> {
  /// Identifies an interceptor in the interceptor chain
  String get id => null;

  /// Output of the interceptor after executing [before] method
  OutputType get output;

  const Interceptor();

  /// Shall be called before execution of route handler
  FutureOr<Null> before(Context ctx);

  /// Executes a route chain
  static Future<Response<RespType>> chain<RespType, RouteRespType>(
      final Context ctx,
      final List<InterceptorCreator> interceptorCreators,
      final RouteFunc<RouteRespType> routeHandler,
      final RouteBase routeInfo) async {
    Response resp;

    final exceptList = <FullInterceptor>[];

    try {
      for (InterceptorCreator creator in interceptorCreators) {
        final Interceptor interceptor = creator(ctx);
        await interceptor.before(ctx);
        if (interceptor is FullInterceptor) exceptList.add(interceptor);
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

      while (exceptList.length > 0) {
        final FullInterceptor interceptor = exceptList.last;
        final newResp = await interceptor.after(ctx, resp);
        if (newResp != null) resp = newResp;
        exceptList.removeLast();
      }
    } catch (e) {
      for (FullInterceptor interceptor in exceptList.reversed) {
        await interceptor.onException();
      }
      rethrow;
    }

    return resp as Response<RespType>;
  }
}
