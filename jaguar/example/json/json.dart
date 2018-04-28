library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

import '../common/models/book/book.dart';

final books = <Book>[];

@Controller(path: '/book')
class BooksApi {
  @PostJson()
  Future<List<Book>> addBook(Context ctx) async {
    // Decode request body as JSON Map
    final Book book = await ctx.bodyAsJson(convert: Book.map);
    books.add(book);
    // Encode Map to JSON
    return books;
  }
}

Future<Null> main(List<String> args) async {
  // Serve
  final server = new Jaguar(port: 8000);
  server.addApi(reflect(new BooksApi()));
  await server.serve();

  // Lets test the server
  print(await resty
      .post('/book')
      .authority('http://localhost:8000')
      .json(new Book.make('0', 'Book0', ['Author0']))
      .fetchList(Book.map));
  print(await resty
      .post('/book')
      .authority('http://localhost:8000')
      .json(new Book.make('1', 'Book1', ['Author1']))
      .fetchList(Book.map));

  await server.close();
}
