import 'dart:async';

import 'package:conn_pool/conn_pool.dart';
import 'package:postgres/postgres.dart';

/// [ConnectionManager] for Postgres database
class PostgresManager extends ConnectionManager<PostgreSQLConnection> {
  /// Hostname of database this connection refers to.
  final String host;

  /// Port of database this connection refers to.
  final int port;

  /// Name of database this connection refers to.
  final String databaseName;

  /// Username for authenticating this connection.
  final String username;

  /// Password for authenticating this connection.
  final String password;

  /// Whether or not this connection should connect securely.
  final bool useSsl;

  /// The amount of time this connection will wait during connecting before
  /// giving up.
  final int timeoutInSeconds;

  /// The timezone of this connection for date operations that don't specify a
  /// timezone.
  final String timeZone;

  PostgresManager(this.databaseName,
      {this.host: 'localhost',
      this.port: 5432,
      this.username: 'postgres',
      this.password,
      this.useSsl: false,
      this.timeoutInSeconds: 30,
      this.timeZone: "UTC"});

  @override

  /// Opens a new [PostgreSQLConnection]
  Future<PostgreSQLConnection> open() async {
    PostgreSQLConnection conn = PostgreSQLConnection(host, port, databaseName,
        username: username,
        password: password,
        useSSL: useSsl,
        timeoutInSeconds: timeoutInSeconds,
        timeZone: timeZone);
    await conn.open();
    return conn;
  }

  @override

  /// Closes the [connection]
  Future<void> close(PostgreSQLConnection connection) {
    return connection.close();
  }
}
