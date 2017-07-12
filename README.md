[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)

# Jaguar

Jaguar is a production ready server framework built for **speed, simplicity and extensiblity**

# Advantages of Jaguar

1. Batteries included
    1. Database
        1. [Fluent query builder](https://github.com/Jaguar-dart/jaguar_query)
        2. [ORM](https://github.com/Jaguar-dart/jaguar_orm)
        3. Migration support
        3. Various databases support
            1. [Mongo](https://github.com/Jaguar-dart/jaguar_mongo)
            2. [PostgreSQL](https://github.com/Jaguar-dart/jaguar_postgresql) ([Query](https://github.com/Jaguar-dart/jaguar_query_postgresql))
            3. [MySQL](https://github.com/Jaguar-dart/jaguar_sqljocky) ([Query](https://github.com/Jaguar-dart/jaguar_query_sqljocky))
            4. OracleDB
            5. MS SQL
    3. [Authentication and Authorization](https://github.com/Jaguar-dart/jaguar_auth)
    4. [OAuth](https://github.com/Jaguar-dart/jaguar_oauth)
    5. [Session management](https://github.com/Jaguar-dart/jaguar_session)
2. Build your routes the way you prefer
    1. Controller based
        1. Reflect
        2. Generate
    2. Mux based
3. [Extensible interceptor infrastructure](https://github.com/Jaguar-dart/jaguar/wiki/Interceptor)
4. [Extensive respository of examples](https://github.com/Jaguar-examples)
    1. [Annotation based](https://github.com/jaguar-examples/boilerplate)
    2. [Reflection based](https://github.com/jaguar-examples/boilerplate_reflect)
    3. [Mux based](https://github.com/jaguar-examples/boilerplate_mux)
    4. [MongoDB](https://github.com/jaguar-examples/boilerplate_mongo)
    5. [PostgreSQL](https://github.com/jaguar-examples/boilerplate_postgresql)
    6. [MySQL](https://github.com/jaguar-examples/boilerplate_sqljocky)
    7. [Upload files using Jaguar](https://github.com/jaguar-examples/upload_file)

# Usage

## Swiftly build REST Api

Below example shows how to add routes to Jaguar.dart server.

```dart
@Api(path: '/api')
class ExampleApi {
  /// This route shows how to write JSON response in jaguar.dart.
  /// [Response] class has a static constructor method called [json]. This
  /// method encodes the given Dart built-in object to JSON string
  @Get(path: '/hello')
  Response<String> sayHello(Context ctx) => Response.json({
        "greeting": "Hello",
      });


  /// This route shows how to read JSON request and write JSON response in
  /// jaguar.dart.
  @Post(path: '/math')
  Future<Response<String>> math(Context ctx) async {
    /// [bodyAsJsonMap] method on [Request] object can be used to decode JSON
    /// body of the request into Dart built-in object
    final Map body = await ctx.req.bodyAsJsonMap();
    final int a = body['a'];
    final int b = body['b'];

    return Response.json({
      'addition': a + b,
      'subtraction': a - b,
      'multiplication': a * b,
      'division': a ~/ b,
    });
  }
}
```

## JSON serialization with little effort

> TODO

## Connect to MongoDB

> TODO

## Connect to PostgreSQL

> TODO

## Add user authentication

> TODO

## Join us on Gitter

- [jaguar](https://gitter.im/jaguar_dart/jaguar)
- [dart server](https://gitter.im/dart-lang/server)
