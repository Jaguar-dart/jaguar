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
    Map<String, String> headers;

    for (String key in headers.keys) {
      request.response.headers.add(key, headers[key]);
    }
  }
}
