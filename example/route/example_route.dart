library example.routes;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';

import '../common/models/book/book.dart';

import '../common/interceptors/db.dart';

part 'example_route.g.dart';

List<Book> _books = [
  new Book.make('0', 'Book1', ['Author1', 'Author2']),
  new Book.make('1', 'Book2', ['Author3', 'Author2']),
  new Book.make('2', 'Book3', ['Author1', 'Author3']),
];

@Api(path: '/api/book')
class BooksApi extends Object with _$JaguarBooksApi {
  /// Example of [Route] annotation. Can specify optional path, allowed methods,
  /// default status code and headers.
  @Route(
      path: '/books',
      methods: const <String>['GET'],
      statusCode: 201,
      headers: const {"sample-header": "made-with.jaguar"})
  List<Map> routeAnnotation() {
    return _books.map((book) => book.toMap()).toList();
  }

  /// Can also use [Get], [Post], [Put], [Delete] annotations to specify routes.
  /// Can specify optional path, default status code and headers.
  @Get(statusCode: 201, headers: const {"sample-header": "made-with.jaguar"})
  List<Map> getAnnotation() {
    return _books.map((book) => book.toMap()).toList();
  }

  /// Example of defining path parameter in url [path] of Route annotation and
  /// inputting it in route handler
  @Delete(path: '/:id')
  Map pathParameter(String id) {
    Book book =
        _books.firstWhere((Book book) => book.id == id, orElse: () => null);

    if (book is! Book) {
      throw new JaguarError(HttpStatus.NOT_FOUND, 'Book not found!',
          'Book with id $id not found!');
    }

    _books.remove(book);

    return book.toMap();
  }

  /// HttpRequest for the current request is automatically inputted if it is the
  /// first argument of route handler
  @Post(path: '/inject/httprequest')
  void inputHttpRequest(HttpRequest req) {}

  /// Example of getting interceptor result as input to Route handler.
  /// The interceptor [MongoDb] opens a [Db] makes it available for inputting.
  /// [Input] annotation can be used to request inputting of result of certain
  /// interceptor.
  @Route(path: '/user', methods: const <String>['DELETE'])
  @WrapMongoDb(dbName: 'store')
  @Input(MongoDb)
  void delete(HttpRequest request, Db db) {}
}

Future<Null> main(List<String> args) async {
  Configuration configuration = new Configuration();
  configuration.addApi(new BooksApi());

  await serve(configuration);
}
