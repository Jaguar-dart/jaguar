library test.jaguar.interceptor.custom_interceptor;

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'dart:convert';

part 'custom_interceptor.g.dart';

final Random rand = new Random.secure();

class GenRandom extends Interceptor {
  int output;

  before(Context ctx) {
    output = rand.nextInt(1000);
    ctx.addInterceptor(GenRandom, id, this);
  }
}

class DoublesRandom extends Interceptor {
  int output;

  before(Context ctx) {
    output = ctx.getInterceptorResult(GenRandom) * 2;
    ctx.addInterceptor(DoublesRandom, id, this);
  }
}

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  static GenRandom genRandom(Context ctx) => new GenRandom();

  static DoublesRandom doublesRandom(Context ctx) => new DoublesRandom();

  @Get(path: '/random')
  @Wrap(const [genRandom, doublesRandom])
  Response<String> getRandom(Context ctx) => Response.json({
        'Random': ctx.getInterceptorResult(GenRandom),
        'Doubled': ctx.getInterceptorResult(DoublesRandom),
      });
}

void main() {
  group('Custom interceptor:Generated', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new ExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });

  group('Custom interceptor:Reflected', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(reflect(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });
}

grouped() {
  test('one interceptor', () async {
    Uri uri = new Uri.http('localhost:8000', '/api/random');
    http.Response response = await http.get(uri);

    expect(response.statusCode, 200);
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'application/json; charset=utf-8');
    Map body = JSON.decode(response.body);
    expect(body['Random'] * 2, body['Doubled']);
  });
}
