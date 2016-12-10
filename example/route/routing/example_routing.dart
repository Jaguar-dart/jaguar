library example.routes;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';

import '../../common/models/book/book.dart';

import '../../common/interceptors/db.dart';

part 'example_routing.g.dart';

List<Book> _books = [
  new Book.make('0', 'Book1', ['Author1', 'Author2']),
  new Book.make('1', 'Book2', ['Author3', 'Author2']),
  new Book.make('2', 'Book3', ['Author1', 'Author3']),
];

@Api(path: '/api/book')
class BooksApi extends Object with _$JaguarBooksApi implements RequestHandler {
  /// Simple [Route] annotation. Specifies path of the route using path argument.
  @Route(path: '/books')
  List<Map> getAllBooks() => _books.map((book) => book.toMap()).toList();

  /// [methods] lets routes specify methods the route should respond to. By default,
  /// a route will respond to GET, POST, PUT, PATCH, DELETE and OPTIONS methods.
  @Route(path: '/books', methods: const <String>['GET'])
  List<Map> getAllBooks1() => _books.map((book) => book.toMap()).toList();

  /// [Get] is a sugar to respond to only GET requests. Similarly sugars exist for
  /// [Post], [Put], [Delete]
  @Get(path: '/books')
  List<Map> getAllBooks2() => _books.map((book) => book.toMap()).toList();

  /// [statusCode] and [headers] arguments lets route annotations specify default
  /// Http status and headers
  @Post(
      path: '/inject/httprequest',
      statusCode: 200,
      headers: const {'custom-header': 'custom data'})
  void defaultStatusAndHeader() {}

  /// HttpRequest for the current request is automatically provided if it is the
  /// first argument of route handler
  @Post(path: '/inject/httprequest')
  void inputHttpRequest(HttpRequest req) {}
}

Future<Null> main(List<String> args) async {
  Configuration configuration = new Configuration();
  configuration.addApi(new BooksApi());

  await serve(configuration);
}
