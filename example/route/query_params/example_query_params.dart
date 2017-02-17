library example.routes;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

import '../../common/models/book/book.dart';

part 'example_query_params.g.dart';

Map<String, Book> _books = {
  "0": new Book.make('0', 'Book1', ['Author1', 'Author2']),
  "1": new Book.make('1', 'Book2', ['Author3', 'Author2']),
  "2": new Book.make('2', 'Book3', ['Author1', 'Author3']),
};

int _id = 3;

String _newId() => (_id++).toString();

@Api(path: '/api/book')
class BooksApi {
  /// Jaguar automatically provides query parameter through optional named parameters
  /// of the route handler
  @Post()
  void createBook({String book, String author}) {
    String newId = _newId();
    _books[newId] = new Book.make(newId, book, [author]);
  }
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarBooksApi());

  await jaguar.serve();
}
