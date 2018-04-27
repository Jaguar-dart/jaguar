library example.routes;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@Api(path: '/api/book')
class BooksApi {
  @Get()
  String getAsString(Context ctx) => ctx.query.get('key');

  @Get()
  int getAsInt(Context ctx) => ctx.query.getInt('key');

  @Get()
  double getAsDouble(Context ctx) => ctx.query.getDouble('key');

  @Get()
  num getAsNum(Context ctx) => ctx.query.getNum('key');
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(reflect(new BooksApi()));

  await jaguar.serve();
}
