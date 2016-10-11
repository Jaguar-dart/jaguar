library api;

import 'dart:async';
import 'dart:io';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';

part 'api.g.dart';

class UsersResource {
  @Route(methods: const <String>['POST'])
  users(HttpRequest request) {
    print("users");
  }
}

@Api(name: 'test', version: 'v1')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route(path: 'ping/([a-z]+)', methods: const ['POST'])
  void ping(String name) {
    print(name);
  }

  @Route(path: 'test', methods: const ['POST'])
  @EncodeMapOrListToJson()
  Map<String, String> test() {
    return {"a": "dbName1", "b": "dbName2"};
  }

  @Group(name: 'users')
  UsersResource users = new UsersResource();
}
