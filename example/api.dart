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
  List<int> getUserWithId(HttpRequest request, String id, {String toto}) {
    request.response..writeln(id)..writeln(toto);
    return [12, 13];
  }
}

@DecodeBodyToJson()
@Api(name: 'test', version: 'v1')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route(path: 'ping', methods: const ['POST'])
  Map<String, String> ping(Map<String, String> json) {
    return json;
  }

  @Route(path: 'test', methods: const ['POST'])
  test(HttpRequest request, Map<String, String> json) {
    print(json);
    return json;
  }

  @Group(path: 'users')
  UserResource users = new UserResource();
}
