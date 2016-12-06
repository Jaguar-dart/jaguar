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

  final MongoDbState state;

  const MongoDb(this.dbName, {String id, this.state}) : super(id: id);

  static MongoDbState createState() => new MongoDbState();

  Future<Db> pre() async {
    state.db = new Db();
    return state.db;
  }

  Future<Null> post() async {
    await state.db.close();
  }
}
