library example.routes;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

part 'path_variables.g.dart';

@Api(path: '/api')
class BooksApi {
  @Get(path: '/book/:id')
  String getAsString(Context ctx) => ctx.pathParams.get('id');

  @Get(path: '/book/:id')
  int getAsInt(Context ctx) => ctx.pathParams.getInt('id');

  @Get(path: '/book/:id')
  double getAsDouble(Context ctx) => ctx.pathParams.getDouble('id');

  @Get(path: '/book/:id')
  num getAsNum(Context ctx) => ctx.pathParams.getNum('id');
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarBooksApi(new BooksApi()));

  await jaguar.serve();
}
