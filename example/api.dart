library api;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

part 'api.g.dart';

class UserResource {
  @Route(methods: const ['GET'])
  Future<Null> getUser(HttpRequest request) async {
    print("get user");
  }

  @Route(path: '([a-zA-Z0-9]+)', methods: const ['GET'])
  Future<Null> getUserWithId(HttpRequest request, List<String> params) async {
    request.response.write(params);
  }
}

@Api(name: 'test', version: 'v1')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route(path: 'ping', methods: const ['GET'])
  Future<Null> get(HttpRequest request) async {
    request.response.write("pong");
  }

  @Group(path: 'users')
  UserResource users = new UserResource();
}
