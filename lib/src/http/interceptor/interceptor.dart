library jaguar.http.interceptor;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

/// An interceptor wraps a route and performs an action before and
/// after the route handler.
///
/// [pre] is the code that is executed before route handler
///
/// [post] is the code that is executed after route handler
///
/// [onException] is executed if there is an exception in the route chain.
/// This can be used to clean up resources used by the interceptor.
abstract class Interceptor<OutputType, ResponseType, InResponseType> {
  /// Identifies an interceptor in the interceptor chain
  String get id => null;

  const Interceptor();

  /// Shall be called before execution of route handler
  /// \param ctx  Request context
  /// \returns    Returns the output of the interceptor
  FutureOr<OutputType> pre(Context ctx);

  /// Shall be called after execution of route handler
  /// \param ctx    Request context
  /// \param inResp Incoming response
  /// \returns      Transformed response
  FutureOr<Response<ResponseType>> post(
          Context ctx, Response<InResponseType> inResp) async =>
      null;

  /// Shall be called if there is an exception in the route chain.
  /// This can be used to clean up resources used by the interceptor.
  Future<Null> onException() async {}

  static FutureOr<Response<RespType>> chain<RespType, RouteRespType>(
      Context ctx,
      List<Interceptor> interceptors,
      RouteFunc<RouteRespType> routeHandler,
      RouteBase routeInfo) async {
    Response resp;

    final exceptList = <Interceptor>[];

    try {
      for (Interceptor interceptor in interceptors) {
        exceptList.add(interceptor);
        final output = await interceptor.pre(ctx);
        ctx.addOutput(
            interceptor.runtimeType, interceptor.id, interceptor, output);
      }

      {
        final res = await routeHandler(ctx);
        if (res is Response) {
          resp = res;
        } else {
          resp = new Response<RespType>(res,
              headers: routeInfo.headers, statusCode: routeInfo.statusCode);
          resp.headers.mimeType = routeInfo.mimeType;
          resp.headers.charset = routeInfo.charset;
        }
      }

      for (Interceptor interceptor in interceptors.reversed) {
        final newResp = await interceptor.post(ctx, resp);
        if (newResp != null) {
          resp = newResp;
        }
        exceptList.removeLast();
      }
    } catch (e) {
      for (Interceptor interceptor in exceptList.reversed) {
        await interceptor.onException();
      }
      rethrow;
    }

    return resp as Response<RespType>;
  }
}
