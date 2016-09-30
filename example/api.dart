library api;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:jaguar/jaguar.dart';

part 'api.g.dart';

class UsersResource {
  @Route(methods: const <String>['POST'])
  users() {
    print("users");
  }
}

@Api(name: 'test', version: 'v1')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route(path: 'ping/([a-z]+)', methods: const ['POST'])
  void ping(String name) {
    print(name);
  }

  @OpenDbExample(dbName: 'test1')
  @OpenDbExample(dbName: 'test2')
  @Route(path: 'test', methods: const ['POST'])
  @EncodeMapOrListToJson()
  @CloseDbExample()
  @CloseDbExample()
  Map<String, String> test(String dbName1, String dbName2) {
    print(dbName1);
    print(dbName2);
    return {"a": dbName1, "b": dbName2};
  }

  @Group(name: 'users')
  UsersResource users = new UsersResource();
}
