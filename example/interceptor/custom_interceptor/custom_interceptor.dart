library example.routes;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:jaguar/jaguar.dart';

import 'package:jaguar/interceptors.dart';

part 'custom_interceptor.g.dart';

final Random rand = new Random.secure();

class WrapGenRandom extends RouteWrapper<GenRandom> {
  String get id => null;

  GenRandom createInterceptor() => new GenRandom();
}

class GenRandom extends Interceptor {
  int pre() {
    print("Executes before request handler!");
    return rand.nextInt(1000);
  }

  void post() {
    print("Executes after request handler!");
  }
}

class WrapUsesRandom extends RouteWrapper<UsesRandom> {
  String get id => null;

  UsesRandom createInterceptor() => new UsesRandom();
}

class UsesRandom extends Interceptor {
  /// [HttpRequest] object of the current request is automatically provided when
  /// first argument of interceptor method is [HttpRequest]
  void pre(HttpRequest req) {
    print("Executes before request handler on path: ${req.uri}!");
  }

  /// [HttpRequest] object of the current request is automatically provided when
  /// first argument of interceptor method is [HttpRequest]
  void post(HttpRequest req) {
    print("Executes after request handler on path: ${req.uri}!");
  }
}

@Api(path: '/api/book')
class BooksApi {
  final WrapGenRandom genRandom = new WrapGenRandom();

  final WrapUsesRandom usesRandom = new WrapUsesRandom();

  final WrapEncodeToJson jsonEncoder = new WrapEncodeToJson();

  /// TODO add documentation
  @Get()
  @InterceptWith(const [#jsonEncoder, #genRandom, #usesRandom])
  Map getJaguarInfo() => {
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      };
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarBooksApi());

  await jaguar.serve();
}
