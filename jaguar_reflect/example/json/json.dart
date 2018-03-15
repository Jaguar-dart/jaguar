library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

import '../common/models/book/book.dart';

final book = new Book.make('0', 'Book1', ['Author1', 'Author2']);

@Api(path: '/api/book')
class BooksApi {
  @GetJson()
  Map addBook(Context ctx) => book.toMap();
}

Future<Null> main(List<String> args) async {
  final jaguar = new Jaguar(port: 8005);
  jaguar.addApi(reflect(new BooksApi()));
  await jaguar.serve();
}
