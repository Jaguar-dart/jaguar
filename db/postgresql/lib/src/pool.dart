import 'dart:async';

import 'package:connection_pool/connection_pool.dart';
import 'package:postgresql/postgresql.dart' as pg;

class PostgresqlDbPool extends ConnectionPool<pg.Connection> {
  String uri;

  PostgresqlDbPool(this.uri, {int poolSize: 10}) : super(poolSize);

  @override
  void closeConnection(pg.Connection connection) {
    connection.close();
  }

  @override
  Future<pg.Connection> openNewConnection() => pg.connect(uri);

  /// Collection of named pools
  static Map<String, PostgresqlDbPool> _pools = {};

  /// Creates a named pool or returns an existing one if the pool with given
  /// name already exists
  factory PostgresqlDbPool.Named(String uri, {int poolSize: 10}) {
    final String name = '$uri/$poolSize';
    if (_pools[name] == null) {
      _pools[name] = new PostgresqlDbPool(uri, poolSize: poolSize);
    }

    return _pools[name];
  }
}
