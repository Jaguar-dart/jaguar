library example.decode.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

import '../../common/models/book/book.dart';

part 'json.g.dart';

final book = new Book.make('0', 'Book1', ['Author1', 'Author2']);

@Api(path: '/api/book')
class BooksApi extends _$JaguarBooksApi {
  @Post()
  Future<Response<String>> addBook(Context ctx) async {
    // Decode request body as JSON Map
    final Map<String, dynamic> json = await ctx.req.bodyAsJsonMap();
    Book book = new Book.fromMap(json);
    print(book.toMap());
    // Encode Map to JSON
    return Response.json(book.toMap());
  }
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new BooksApi());

  await jaguar.serve();
}
