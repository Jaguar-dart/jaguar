library jaguar_postgres.src.interceptor;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:connection_pool/connection_pool.dart';

import 'pool.dart';

class PostgresDb extends Interceptor {
  /// ID for the interceptor instance
  final String id;

  final String uri;

  final int poolSize;

  /// The connection pool
  PostgresqlDbPool _pool;

  /// The connection
  ManagedConnection<pg.Connection> _managedConnection;

  /// Returns the mongodb connection
  pg.Connection get conn => _managedConnection?.conn;

  PostgresDb(this.uri, {this.poolSize: 10, this.id});

  Future<pg.Connection> pre(Context ctx) async {
    _pool = new PostgresqlDbPool.Named(uri, poolSize: poolSize);
    _managedConnection = await _pool.getConnection();
    return conn;
  }

  /// Closes the connection on route exit
  void post(Context ctx, Response incoming) {
    _releaseConn();
  }

  /// Closes the connection in case an exception occurs in route chain before
  /// [post] is called
  Future<Null> onException() async {
    _releaseConn();
  }

  /// Releases connection
  void _releaseConn() {
    if (_managedConnection != null) {
      _pool.releaseConnection(_managedConnection);
      _managedConnection = null;
    }
  }
}
