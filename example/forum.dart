library example.forum;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'interceptor.dart';

part 'forum.g.dart';

@Api(name: '/api')
class Forum extends Object with _$JaguarForum {
  @Route('/user', methods: const <String>['GET'])
  @MongoDb('test')
  @Login()
  Future<User> fetch() async {
    return new User();
  }

  @Route('/user', methods: const <String>['DELETE'])
  @MongoDb('test')
  @Login()
  @Input(MongoDb)
  void delete(HttpRequest request, Db db) {}

  /*
  List<Route> _routes = <Route>[
    new Route(r"/api/user", methods: ["GET"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;

    {
      match = _routes[0].match(args, request.uri.path, request.method);

      if (match) {
        MongoDb iMongoDb = new MongoDb('test');

        final rMongoDb = iMongoDb.pre();

        Login iLogin = new Login();
        iLogin.pre(rMongoDb);

        getUser();

        iMongoDb.post();

        return true;
      }
    }

    return false;
  }
  */
}
