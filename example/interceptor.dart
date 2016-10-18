library example.forum.interceptor;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

class Db {}

class User {}

@InterceptDual(returns: Db)
class MongoDb {
  final String dbName;

  const MongoDb(this.dbName);

  Future<Db> pre() async {
    return new Db();
  }

  Future post() async {}
}

@InterceptDual(returns: User)
class Login {
  const Login();

  @Input(MongoDb)
  void pre(Db db) {}

  void post() {}
}
