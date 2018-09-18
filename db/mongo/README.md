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

Use `injectInterceptor` method of `MongoPool` to get a connection to MongoDB. `injectInterceptor` automatically
releases the connection after the request has been serviced or if an exception occurs.

```dart
  @GetJson()
  Future<List> readAll(Context ctx) async {
     Db db = await mongoPool.injectInterceptor(ctx); // Get [Db]
    // Use Db to fetch items
    return await (await db.collection('contact').find()).toList();
  }
```