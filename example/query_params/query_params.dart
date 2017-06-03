library example.routes;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

part 'query_params.g.dart';

@Api(path: '/api/book')
class BooksApi {
  @Get()
  String getAsString(Context ctx) => ctx.queryParams.get('key');

  @Get()
  int getAsInt(Context ctx) => ctx.queryParams.getInt('key');

  @Get()
  double getAsDouble(Context ctx) => ctx.queryParams.getDouble('key');

  @Get()
  num getAsNum(Context ctx) => ctx.queryParams.getNum('key');
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarBooksApi(new BooksApi()));

  await jaguar.serve();
}
