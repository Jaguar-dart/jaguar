library source_gen.test.example;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/interceptors.dart';
import 'package:jaguar/jaguar.dart';

part 'api_test_example.g.dart';

@Api()
class ApiWithoutParam extends _$JaguarApiWithoutParam {}

@Api(name: 'api')
class ApiWithName extends _$JaguarApiWithName {}

@Api(version: 'v1')
class ApiWithVersion extends _$JaguarApiWithVersion {}

@Api(name: 'api', version: 'v1')
class ApiWithNameAndVersion extends _$JaguarApiWithNameAndVersion {}

@Api()
class ApiWithoutParamWithSimpleRoute
    extends _$JaguarApiWithoutParamWithSimpleRoute {
  @Route(path: 'ping')
  void ping() {}
}

@Api()
class ApiWithoutParamWithSimpleRouteWithHttpRequest
    extends _$JaguarApiWithoutParamWithSimpleRouteWithHttpRequest {
  @Route(path: 'ping')
  void ping(HttpRequest request) {}
}

@Api()
class ApiWithoutParamWithFutureRoute
    extends _$JaguarApiWithoutParamWithFutureRoute {
  @Route(path: 'ping')
  Future<Null> ping() async {}
}

@Api()
class ApiWithoutParamWithFutureRouteWithHttpRequest
    extends _$JaguarApiWithoutParamWithFutureRouteWithHttpRequest {
  @Route(path: 'ping')
  Future<Null> ping(HttpRequest request) async {}
}

@Api(name: 'api')
class ApiWithNameWithSimpleRoute extends _$JaguarApiWithNameWithSimpleRoute {
  @Route(path: 'ping')
  void ping() {}
}

@Api(name: 'api', version: 'v1')
class ApiWithNameAndVersionWithSimpleRoute
    extends _$JaguarApiWithNameAndVersionWithSimpleRoute {
  @Route(path: 'ping')
  void ping() {}
}
