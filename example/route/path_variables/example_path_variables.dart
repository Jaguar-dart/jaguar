library example.routes;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';

import '../../common/models/book/book.dart';

import '../../common/interceptors/db.dart';

part 'example_path_variables.g.dart';

Map<String, Book> _books = {
  "0": new Book.make('0', 'Book1', ['Author1', 'Author2']),
  "1": new Book.make('1', 'Book2', ['Author3', 'Author2']),
  "2": new Book.make('2', 'Book3', ['Author1', 'Author3']),
};

int _id = 3;

String _newId() => (_id++).toString();

@Api(path: '/api')
class BooksApi extends Object with _$JaguarBooksApi {
  /// Path variables can be defined in the path argument of route annotations by
  /// beginning the path segment with ':'. The path variable identifier follows ':'.
  /// Jaguar will automatically provide the path variable if it finds corresponding
  /// required argument in route handler.
  @Get(path: '/book/:id')
  String getBookById(String id) => _books[id]?.toJson();

  /// Jaguar can parse multiple path variables in same route annotation
  @Post(path: '/book/:book/:author')
  void createBook(String book, String author) {
    String newId = _newId();
    _books[newId] = new Book.make(newId, book, [author]);
  }
}

Future<Null> main(List<String> args) async {
  Configuration configuration = new Configuration();
  configuration.addApi(new BooksApi());

  await serve(configuration);
}
