library example.decode.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

import '../../common/models/book/book.dart';

final book = new Book.make('0', 'Book1', ['Author1', 'Author2']);

@Api(path: '/api/book')
class BooksApi {
  @PostJson()
  Future<Book> addBook(Context ctx) async {
    // Decode request body as JSON Map
    final Book book = await ctx.req.bodyAsJson(convert: Book.map);
    print(book.toMap());
    // Encode Map to JSON
    return book;
  }
}

Future<Null> main(List<String> args) async {
  final server = new Jaguar();
  server.addApi(reflect(new BooksApi()));
  await server.serve();
}
