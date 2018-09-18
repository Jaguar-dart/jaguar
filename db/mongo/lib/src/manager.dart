import 'dart:async';

import 'package:conn_pool/conn_pool.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

/// [ConnectionManager] for Mongo
class MongoDbManager extends ConnectionManager<mongo.Db> {
  /// URI of mongo server to connect to
  final String uri;

  /// Write concern used when connecting to the db
  final mongo.WriteConcern writeConcern;

  MongoDbManager(this.uri,
      {this.writeConcern: mongo.WriteConcern.ACKNOWLEDGED});

  /// Opens a new connection
  @override
  Future<mongo.Db> open() async {
    mongo.Db db = new mongo.Db(uri);
    await db.open(writeConcern: writeConcern);
    return db;
  }

  /// Closes the connection
  @override
  Future<void> close(mongo.Db db) => db.close();
}
