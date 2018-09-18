# conn_pool

Manages a pool of connections.

# Shared pool

## Creating a pool

`Pool` requires an instance of `ConnectionManager` to open and close connections.
In this article, we will use `PostgresManager` for demonstration purposes.

```dart
final pool = SharedPool(PostgresManager('exampleDB'), minSize: 5, maxSize: 10);
```

## Getting connection

```dart
Connection<PostgreSQLConnection> conn = await pool.get();
PostgreSQLConnection db = conn.connection;
await db.execute(
        "CREATE TABLE posts (id SERIAL PRIMARY KEY, name VARCHAR(255), age INT);");
```

## Releasing the connection to the pool

```dart
await conn.release();
```