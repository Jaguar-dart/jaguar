library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

import '../common/models/book/book.dart';

dynamic x(dynamic ctx) => new Response(null);

Future<dynamic> x1(dynamic ctx) async => new Response(null);

String x2(dynamic ctx) => '';

Future<String> x3(dynamic ctx) async => '';

Response x4(dynamic ctx) => null;

Future<Response> x5(dynamic ctx) async => null;

Future<Null> main(List<String> args) async {
  print(simpleHandler(null, null, x));
  print(simpleHandler(null, null, x1));
  print(simpleHandler(null, null, (Context c) => new Response(null)));
  print(simpleHandler(null, null, x2));
  print(simpleHandler(null, null, x3));
  print(simpleHandler(null, null, x4));
  print(simpleHandler(null, null, x5));

  /* TODO
  final server = new Jaguar();
  server.post('/api/book', (Context ctx) async {
    // Decode request body as JSON Map
    final Map<String, dynamic> json = await ctx.req.bodyAsJsonMap();
    Book book = new Book.fromMap(json);
    // Encode Map to JSON
    return Response.json(book.toMap());
  });

  await server.serve();
  */
}
