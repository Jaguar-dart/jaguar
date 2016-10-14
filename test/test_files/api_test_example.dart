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

class MyEmptyGroup {}

@Api()
class ApiWithGroup extends _$JaguarApiWithGroup {
  @Group(name: 'myGroup')
  MyEmptyGroup myGroup = new MyEmptyGroup();
}

class GroupWithOneRoute {
  @Route(path: 'ping')
  void ping() {}
}

@Api()
class ApiWithGroupWithSimpleRoute extends _$JaguarApiWithGroupWithSimpleRoute {
  @Group(name: 'myGroup')
  GroupWithOneRoute myGroup = new GroupWithOneRoute();
}

@Api()
class ApiAndRouteWithParam extends _$JaguarApiAndRouteWithParam {
  @Route(path: 'users/([a-zA-Z])')
  void ping(String id) {}
}

@Api()
class ApiAndRouteWithHttpRequestAndParam
    extends _$JaguarApiAndRouteWithHttpRequestAndParam {
  @Route(path: 'users/([a-zA-Z])')
  void ping(HttpRequest request, String id) {}
}

@Api()
class ApiAndRouteWithQueryParameter
    extends _$JaguarApiAndRouteWithQueryParameter {
  @Route(path: 'users')
  void ping({String name}) {}
}
