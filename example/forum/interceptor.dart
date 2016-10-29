library example.forum.interceptor;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

class Db {}

class User {}

@DefineInterceptDual()
class MongoDb extends InterceptorDual {
  final String dbName;

  const MongoDb(this.dbName, {String id}): super(id: id);

  Future<Db> pre() async {
    return new Db();
  }

  Future post() async {}
}

@DefineInterceptDual()
class Login extends InterceptorDual {
  const Login();

  @Input(MongoDb, id: 'Admin')
  void pre(Db db) {}

  void post() {}
}
