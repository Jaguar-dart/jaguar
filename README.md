[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)

# Jaguar

Jaguar is a production ready server framework built for **speed, simplicity and extensiblity**

## Advantages of Jaguar

1. Batteries included
    1. ORM
    2. Various databases support
    3. [Authentication and Authorization](https://github.com/Jaguar-dart/jaguar_auth)
    4. [OAuth](https://github.com/Jaguar-dart/jaguar_oauth)
    5. [Session management](https://github.com/Jaguar-dart/jaguar_session)
2. Keeps your route handlers concise and clean
3. Bare metal speed achieved through code generation
4. [Extensible interceptor infrastructure](https://github.com/Jaguar-dart/jaguar/wiki/Interceptor)
5. Various ways to build routes
    1. Class-annotation based
        1. [Reflection based](https://github.com/Jaguar-dart/jaguar_reflect)
        2. Source generation based
    2. [Mux based](https://github.com/Jaguar-dart/jaguar_mux)
6. [Extensive respository of examples](https://github.com/Jaguar-examples)
    1. [Annotation based](https://github.com/jaguar-examples/boilerplate)
    2. [Reflection based](https://github.com/jaguar-examples/boilerplate_reflect)
    3. [Mux based](https://github.com/jaguar-examples/boilerplate_mux)
    4. [MongoDB](https://github.com/jaguar-examples/boilerplate_mongo)
    5. [PostgreSQL](https://github.com/jaguar-examples/boilerplate_postgresql)
    6. [Upload files using Jaguar](https://github.com/jaguar-examples/upload_file)

## Example

### Simple routes

Below example shows route add routes to Jaguar.dart server.

```dart
@Api(path: '/api/book')
class BooksApi {
  /// Simple [Route] annotation. Specifies path of the route using path argument.
  @Route(path: '/books')
  int getFive(Context ctx) => 5;

  /// [methods] lets routes specify methods the route should respond to. By default,
  /// a route will respond to GET, POST, PUT, PATCH, DELETE and OPTIONS methods.
  @Route(path: '/books', methods: const <String>['GET'])
  String getName(Context ctx) => "Jaguar";

  /// [Get] is a sugar to respond to only GET requests. Similarly sugars exist for
  /// [Post], [Put], [Delete]
  @Get(path: '/books')
  String getMoto(Context ctx) => "speed, simplicity and extensiblity";

  /// [statusCode] and [headers] arguments lets route annotations specify default
  /// Http status and headers
  @Post(
      path: '/inject/httprequest',
      statusCode: 200,
      headers: const {'custom-header': 'custom data'})
  void defaultStatusAndHeader(Context ctx) {}
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarBooksApi(new BooksApi()));

  await jaguar.serve();
}
```

## Join us on Gitter

- [jaguar](https://gitter.im/jaguar_dart/jaguar)
- [dart server](https://gitter.im/dart-lang/server)

## Issue

If you have an issue please tell us which version of jaguar and if you can provide
an example this will simplify the path to resolve it :).
