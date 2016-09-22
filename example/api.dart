library api;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:jaguar/jaguar.dart';

part 'api.g.dart';

class UserResource {
  @Route(methods: const ['GET'])
  Future<String> getUser() async {
    return "get user";
  }

  @Route(path: '([a-zA-Z0-9]+)', methods: const ['GET'])
  void getUserWithId(HttpRequest request, String id) {
    request.response.write(id);
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
