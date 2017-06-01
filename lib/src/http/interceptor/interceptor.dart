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
          Context ctx, Response<InResponseType> inResp) async => null;

  /// Shall be called if there is an exception in the route chain.
  /// This can be used to clean up resources used by the interceptor.
  Future<Null> onException() async {}
}
