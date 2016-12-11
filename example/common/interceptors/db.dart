library example.interceptors.db;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

class Db {
  Future close() async {}
}

class MongoDbState {
  Db db;

  MongoDbState();
}

class WrapMongoDb implements RouteWrapper<MongoDb> {
  final String dbName;

  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapMongoDb({this.dbName, this.id});

  MongoDb createInterceptor() => new MongoDb(this.dbName);
}

class MongoDb extends Interceptor {
  final String dbName;

  MongoDbState state = new MongoDbState();

  MongoDb(this.dbName);

  Future<Db> pre() async {
    state.db = new Db();
    return state.db;
  }

  Future<Null> post() async {
    await state.db.close();
  }
}
