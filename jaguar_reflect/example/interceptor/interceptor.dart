library example.routes;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

final Random rand = new Random.secure();

class GenRandom extends FullInterceptor<int, dynamic, dynamic> {
  int output;

  void before(Context ctx) {
    print("Executes before request handler!");
    output = rand.nextInt(1000);
    ctx.addInterceptor(GenRandom, id, this);
  }

  Response after(Context ctx, Response incoming) {
    print("Executes after request handler!");
    return incoming;
  }
}

class UsesRandom extends FullInterceptor {
  Null output;

  /// [HttpRequest] object of the current request is automatically provided when
  /// first argument of interceptor method is [HttpRequest]
  void before(Context ctx) {
    print("Executes before request handler on path: ${ctx.req.uri}!");
  }

  /// [HttpRequest] object of the current request is automatically provided when
  /// first argument of interceptor method is [HttpRequest]
  Response after(Context ctx, Response incoming) {
    print("Executes after request handler on path: ${ctx.req.uri}!");
    return incoming;
  }
}

@Api(path: '/api/book')
class BooksApi {
  static GenRandom genRandom(Context ctx) => new GenRandom();

  UsesRandom usesRandom(Context ctx) => new UsesRandom();

  @Get()
  @Wrap(const [genRandom, #usesRandom])
  Response<String> getJaguarInfo(Context ctx) => Response.json({
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      });
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(reflect(new BooksApi()));

  await jaguar.serve();
}
