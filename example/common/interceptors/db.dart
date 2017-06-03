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

class MongoDb extends Interceptor {
  final String dbName;

  MongoDbState state = new MongoDbState();

  MongoDb(this.dbName);

  Future<Db> pre(Context ctx) async {
    state.db = new Db();
    return state.db;
  }

  Future<Null> post(Context ctx, Response resp) async {
    await state.db.close();
  }
}
