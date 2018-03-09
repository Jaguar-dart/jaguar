library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

import '../common/models/book/book.dart';

Future<Null> main(List<String> args) async {
  final server = new Jaguar();
  server.postJson('/api/book', (Context ctx) async {
    // Decode request body as JSON Map
    Book book = await ctx.req.bodyAsJson(convert: Book.map);
    // Encode Map to JSON
    return book.toMap();
  });

  await server.serve();
}
