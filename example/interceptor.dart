library example.forum.interceptor;

import 'package:jaguar/jaguar.dart';

class Db {}

class User {}

@InterceptDual(returns: Db)
class MongoDb {
  final String dbName;

  const MongoDb(this.dbName);

  Db pre() {
    return new Db();
  }

  void post() {}
}

@InterceptDual(returns: User)
class Login {
  const Login();

  @Input(MongoDb)
  void pre(Db db) {}

  void post() {}
}
