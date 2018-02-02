library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

import '../common/models/book/book.dart';

Future<Null> main(List<String> args) async {
  final server = new Jaguar();
  server.post('/api/book', (Context ctx) async {
    // Decode request body as JSON Map
    final Map<String, dynamic> json = await ctx.req.bodyAsJsonMap();
    Book book = new Book.fromMap(json);
    // Encode Map to JSON
    return Response.json(book.toMap());
  });

  await server.serve();
}
