# jaguar_postgres

A Postgres interceptor for Jaguar. 

# Usage

## Creating the pool

Create an instance of `PostgresPool`. Supply essential database configuration. By default,
`PostgresPool` builds on a `SharedPool`. Supply `minPoolSize` and `maxPoolSize` to control
pool size.

```dart
final postgresPool = PostgresPool('jaguar_learn',
    password: 'dart_jaguar', minPoolSize: 5, maxPoolSize: 10);
```

## Getting and using connection

Use `injectInterceptor` method of `PostgresPool` to get a connection to Postgres. `injectInterceptor` automatically
releases the connection after the request has been serviced or if an exception occurs.

```dart
  @GetJson()
  Future<List<Map>> readAll(Context ctx) async {
    pg.PostgreSQLConnection db = await postgresPool.injectInterceptor(ctx);
    List<Map<String, Map<String, dynamic>>> values =
        await db.mappedResultsQuery("SELECT * FROM contacts;");
    return values.map((m) => m.values.first).toList();
  }
```