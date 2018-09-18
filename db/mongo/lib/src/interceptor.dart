library jaguar_mongo.interceptor;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:conn_pool/conn_pool.dart';

import 'manager.dart';

/// A MongoDB pool
class MongoPool {
  /// The connection pool
  final Pool<mongo.Db> pool;

  MongoPool(String mongoUri,
      {mongo.WriteConcern writeConcern: mongo.WriteConcern.ACKNOWLEDGED,
      int minPoolSize: 10,
      int maxPoolSize: 10})
      : pool = SharedPool(MongoDbManager(mongoUri, writeConcern: writeConcern),
            minSize: minPoolSize, maxSize: maxPoolSize);

  MongoPool.fromPool({this.pool});

  MongoPool.fromManager({MongoDbManager manager}) : pool = SharedPool(manager);

  /// Injects a Postgres interceptor into current route context
  Future<mongo.Db> injectInterceptor(Context context) async {
    Connection<mongo.Db> conn = await pool.get();
    context.addVariable(conn.connection);
    context.after.add((_) => conn.release());
    context.onException.add((Context ctx, _1, _2) => conn.release());
    return conn.connection;
  }
}
