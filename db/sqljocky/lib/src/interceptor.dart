library jaguar_postgres.src.interceptor;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:sqljocky5/sqljocky.dart';
import 'package:conn_pool/conn_pool.dart';

import 'manager.dart';

class MySqlPool {
  /// The connection pool
  final Pool<MySqlConnection> pool;

  MySqlPool(String databaseName,
      {String host: 'localhost',
        int port: 5432,
        String username: 'postgres',
        String password,
        bool useSsl: false,
        int timeoutInSeconds: 30,
        String timeZone: "UTC",
        int minPoolSize: 10,
        int maxPoolSize: 10})
      : pool = SharedPool(
      MySqlManager(databaseName,
          host: host,
          port: port,
          username: username,
          password: password,
          useSsl: useSsl,
          timeoutInSeconds: timeoutInSeconds
      ),
      minSize: minPoolSize,
      maxSize: maxPoolSize);

  MySqlPool.fromPool({this.pool});

  MySqlPool.fromManager({MySqlManager manager})
      : pool = SharedPool(manager);

  /// Injects a Postgres interceptor into current route context
  Future<MySqlConnection> injectInterceptor(Context context) async {
    Connection<MySqlConnection> conn = await pool.get();
    context.addVariable(conn.connection);
    context.after.add((_) => conn.release());
    context.onException.add((Context ctx, _1, _2) => conn.release());
    return conn.connection;
  }
}