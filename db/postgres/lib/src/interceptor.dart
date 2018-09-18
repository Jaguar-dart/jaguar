library jaguar_postgres.src.interceptor;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:postgres/postgres.dart';
import 'package:conn_pool/conn_pool.dart';

import 'manager.dart';

class PostgresPool implements Interceptor<PostgreSQLConnection> {
  /// The connection pool
  final Pool<PostgreSQLConnection> pool;

  PostgresPool(String databaseName,
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
            PostgresManager(databaseName,
                host: host,
                port: port,
                username: username,
                password: password,
                useSsl: useSsl,
                timeoutInSeconds: timeoutInSeconds,
                timeZone: timeZone),
            minSize: minPoolSize,
            maxSize: maxPoolSize);

  PostgresPool.fromPool({this.pool});

  PostgresPool.fromManager({PostgresManager manager})
      : pool = SharedPool(manager);

  /// Injects a Postgres interceptor into current route context
  Future<PostgreSQLConnection> call(Context context) async {
    Connection<PostgreSQLConnection> conn = await pool.get();
    context.addVariable(conn.connection);
    context.after.add((_) => conn.release());
    context.onException.add((Context ctx, _1, _2) => conn.release());
    return conn.connection;
  }
}
