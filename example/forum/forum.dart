library example.forum;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'interceptor.dart';

part 'forum.g.dart';

@Api(path: '/api')
class ForumApi extends Object with _$JaguarForumApi {
  @Route('/user',
      methods: const <String>['GET'],
      statusCode: 201,
      headers: const {"sample-header": "made-with.jaguar"})
  @MongoDb('test', id: 'Test')
  @MongoDb('admin', id: 'Admin')
  @Login()
  Future<User> fetch() async {
    return new User();
  }

  @Route('/user', methods: const <String>['DELETE'])
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  void delete(HttpRequest request, Db db) {
  }

  @Route('/user/:param1', methods: const <String>['POST'])
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  String create(HttpRequest request, Db db, String param1, [int param2 = 25, int param3 = 5]) {
    return param1;
  }

  @Route('/user', methods: const <String>['PUT'])
  @MongoDb('admin', id: 'Admin')
  @Login()
  @Input(MongoDb, id: 'Admin')
  String update(HttpRequest request, Db db, String param1, {int param2: 5555, int param3: 55}) {
    return param1;
  }
}
