library api;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:jaguar/jaguar.dart';

part 'api.g.dart';

class UserResource {
  @Route(methods: const ['POST'])
  Future<Map<String, String>> getUser(Map<String, String> json) async {
    return json;
  }

  @Route(path: '([a-zA-Z0-9]+)', methods: const ['GET'])
  List<int> getUserWithId(
      HttpRequest request, Map<String, dynamic> json, String id,
      {String toto}) {
    return [12, 13];
  }
}

@Api(name: 'test', version: 'v1')
@DecodeBodyToJson()
@EncodeResponseToJson()
class ExampleApi extends Object with _$JaguarExampleApi {
  // @Route(path: 'ping', methods: const ['GET'])
  // Future<Null> get(HttpRequest request) async {
  //   request.response.write("pong");
  // }

  @Group(path: 'users')
  UserResource users = new UserResource();

  @Group(path: 'users1')
  UserResource users1 = new UserResource();
}
