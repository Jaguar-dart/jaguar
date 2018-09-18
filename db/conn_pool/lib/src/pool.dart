import 'dart:async';
import 'counted_set.dart';

/// Creates a [Pool] whose members can be shared. The pool keeps a record of
/// between [minSize] and [maxSize] open items.
///
/// The [manager] contains the logic to open and close connections.
///
/// Example:
///     final pool = SharedPool(PostgresManager('exampleDB'), minSize: 5,
///                    maxSize: 10);
///     createTable() async {
///       Connection<PostgreSQLConnection> conn = await pool.get();
///       PostgreSQLConnection db = conn.connection;
///       await db.execute(
///           "CREATE TABLE posts (id SERIAL PRIMARY KEY, name VARCHAR(255), age INT);");
///       await conn.release();
///     }
class SharedPool<T> implements Pool<T> {
  final ConnectionManager<T> manager;

  final int minSize;
  final int maxSize;
  final _pool = CountedSet<Connection<T>>();

  SharedPool(this.manager, {int minSize: 10, int maxSize: 10})
      : minSize = minSize,
        maxSize = maxSize,
        _d = maxSize - minSize;

  Future<Connection<T>> _createNew() async {
    var conn = Connection._(this);
    _pool.add(1, conn);
    T n = await manager.open();
    conn._connection = n;
    return conn;
  }

  /// Returns a connection
  Future<Connection<T>> get() async {
    if (_pool.numAt(0) > 0 || _pool.length >= maxSize) {
      var conn = _pool.leastUsed;
      _pool.inc(conn);
      return conn;
    }
    return _createNew();
  }

  final int _d;

  /// Releases [connection] back to the pool
  void release(Connection<T> connection) {
    if (_d <= 0) return;
    if (!connection.isReleased) {
      try {
        _pool.dec(connection);
      } catch (e) {}
    }
    if (_pool.length != maxSize) return;
    if (_pool.numAt(0) < _d) return;
    var removes = _pool.removeAllAt(0);
    for (var r in removes) {
      try {
        if (r.isReleased) continue;
        r.isReleased = true;
        manager.close(r.connection);
      } catch (_) {}
    }
  }
}

/// A connection
class Connection<T> {
  /// The connection [Pool] this connection belongs to.
  final Pool<T> pool;

  /// The underlying connection
  T _connection;

  /// Is this connection released to the pool?
  bool isReleased = false;

  Connection._(this.pool);

  T get connection => _connection;

  /// Releases the connection
  Future<void> release() => pool.release(this);
}

/// Interface to open and close the connection [C]
abstract class ConnectionManager<C> {
  /// Establishes and returns a new connection
  FutureOr<C> open();

  /// Closes provided[connection]
  FutureOr<void> close(C connection);
}

/// Interface for pool
abstract class Pool<T> {
  /// Contains logic to open and close connections.
  ConnectionManager<T> get manager;

  /// Returns a new connection
  Future<Connection<T>> get();

  /// Releases [connection] back to the pool.
  FutureOr<void> release(Connection<T> connection);
}

// TODO class ExclusivePool<T> implements Pool<T> {}
