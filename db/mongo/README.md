# jaguar_mongo

A MongoDB interceptor for Jaguar. 

# Usage

## Creating the pool

Create an instance of `MongoPool`. Supply essential database configuration. By default,
`MongoPool` builds on a `SharedPool`. Supply `minPoolSize` and `maxPoolSize` to control the
pool size.

```dart
final mongoPool = MongoPool('mongodb://localhost:27017/test');
```

## Getting and using connection

`MongoPool` implements Jaguar's `Interceptor`. Invoke `mongoPool` with context to get a connection. `MongoPool` automatically
releases the connection after the request has been serviced or if an exception occurs.

```dart
  @GetJson()
  Future<List> readAll(Context ctx) async {
     Db db = await mongoPool(ctx); // Get [Db]
    // Use Db to fetch items
    return await (await db.collection('contact').find()).toList();
  }
```