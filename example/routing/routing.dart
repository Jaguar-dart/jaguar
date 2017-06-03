library example.routes;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

part 'routing.g.dart';

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
