[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)

# Jaguar

Jaguar, a server framework built for **speed, simplicity and extensiblity**.

## Advantages of Jaguar

1. Keeps your route handlers concise and clean
2. Bare metal speed achieved through code generation
3. Extensible interceptor infrastructure
4. Generates API console client to try your server without writing single
line of client code
5. Tests are first class citizens in jaguar
i. Mock HTTP requests and Websocket requests 
ii. Use dependency injection to test your API
6. Optional Firebase/Parse like no code or little code servers

Even though Jaguar is feature rich, it is simpler and easy to get started.

## Example

### Simple routes

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

## The State of Jaguar

Jaguar is currently under development. Feedbacks and contributions are welcome.

## Join us on Gitter

- [jaguar](https://gitter.im/jaguar_dart/jaguar)
- [dart server](https://gitter.im/dart-lang/server)

## Issue

If you have an issue please tell us which version of jaguar and if you can provide
an example this will simplify the path to resolve it :).
