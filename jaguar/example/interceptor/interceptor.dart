library example.routes;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:jaguar/jaguar.dart';

part 'interceptor.g.dart';

final Random rand = new Random.secure();

void genRandom(Context ctx) {
  print("Executes before request handler!");
  ctx.addVariable(rand.nextInt(1000));
  ctx.after.add((Context ctx) {
    print("Executes after request handler!");
  });
}

void usesRandom(Context ctx) {
  print("Executes before request handler on path: ${ctx.req.uri}!");
  ctx.after.add((Context ctx) {
    print("Executes after request handler on path: ${ctx.req.uri}!");
  });
}

@Controller(path: '/api/book')
class BooksApi extends _$JaguarBooksApi {
  @Get()
  @Intercept([genRandom, usesRandom])
  Response<String> getJaguarInfo(Context ctx) => Response.json({
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      });
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.add(new BooksApi());

  await jaguar.serve();
}
