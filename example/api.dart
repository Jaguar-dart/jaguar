library api;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';

part 'api.g.dart';

class UserResource {
  @ApiMethod(methods: const ['GET'])
  Future<Null> getUser(HttpRequest request) async {
    print("get user");
  }

  @ApiMethod(path: '([a-zA-Z0-9]+)', methods: const ['GET'])
  Future<Null> getUserWithId(HttpRequest request, List<String> params) async {
    request.response.write(params);
  }
}

@ApiClass(name: 'test', version: 'v1')
class TestApi extends Object with _$JaguarTestApi {
  @ApiMethod(path: 'ping', methods: const ['GET'])
  Future<Null> get(HttpRequest request) async {
    request.response.write("pong");
  }

  @ApiResource(path: 'users')
  UserResource users = new UserResource();
}
