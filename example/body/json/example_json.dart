library example.body.json;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';

import '../../common/models/book/book.dart';

part 'example_json.g.dart';

List<Book> _books = [
  new Book.make('0', 'Book1', ['Author1', 'Author2']),
  new Book.make('1', 'Book2', ['Author3', 'Author2']),
  new Book.make('2', 'Book3', ['Author1', 'Author3']),
];

int _id = 3; //TODO race condition

@Api(path: '/api/book')
@WrapEncodeToJson()
class BooksApi extends Object with _$JaguarBooksApi {
  @Post()
  @WrapDecodeJsonMap()
  @Input(DecodeJsonMap)
  Map addBook(Map<String, dynamic> json) {
    Book book = new Book();
    book.fromMap(json);
    book.id = (_id++).toString();
    book.validate();
    _books.add(book);
    return book.toMap();
  }

  @Get(path: '/:id')
  Map getById(String id) {
    Book book =
        _books.firstWhere((Book book) => book.id == id, orElse: () => null);

    if (book is! Book) {
      throw new JaguarError(HttpStatus.NOT_FOUND, 'Book not found!',
          'Book with id $id not found!');
    }

    return book.toMap();
  }

  @Delete(path: '/:id')
  Map removeBook(String id) {
    Book book =
        _books.firstWhere((Book book) => book.id == id, orElse: () => null);

    if (book is! Book) {
      throw new JaguarError(HttpStatus.NOT_FOUND, 'Book not found!',
          'Book with id $id not found!');
    }

    _books.remove(book);

    return book.toMap();
  }

  @Put(path: '/:id')
  @WrapDecodeJsonMap()
  @Input(DecodeJsonMap)
  Map updateBook(Map<String, dynamic> json, String id) {
    Book bookReq = new Book();
    bookReq.fromMap(json);
    if (bookReq.id != id) {
      throw new JaguarError(HttpStatus.BAD_REQUEST, 'Invalid request!',
          'Book id in body and path differ!');
    }
    bookReq.validate();

    Book book =
        _books.firstWhere((Book book) => book.id == id, orElse: () => null);

    if (book is! Book) {
      throw new JaguarError(HttpStatus.NOT_FOUND, 'Book not found!',
          'Book with id $id not found!');
    }

    book.fromMap(bookReq.toMap());

    return book.toMap();
  }
}

Future<Null> main(List<String> args) async {
  Configuration configuration = new Configuration();
  configuration.addApi(new BooksApi());

  await serve(configuration);
}
