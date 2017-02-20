library jaguar.http.interceptor;

import 'dart:async';

abstract class RouteWrapper<WrapperType extends Interceptor> {
  /// Id of the interceptor
  String get id => null;

  Type get interceptorType => WrapperType;

  const RouteWrapper();

  WrapperType createInterceptor();
}

/// Base class for interceptor
abstract class Interceptor<OutputType, ResponseType, InResponseType> {
  const Interceptor();

  Future<Null> onException() async {}
}
