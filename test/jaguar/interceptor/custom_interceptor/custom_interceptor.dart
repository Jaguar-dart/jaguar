library test.jaguar.interceptor.custom_interceptor;

import 'dart:async';
import 'dart:math';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

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
    await resty
        .get('/api/random')
        .authority('http://localhost:8000')
        .exact(statusCode: 200, mimeType: 'application/json')
        .json<Map, Map>()
        .then((Map body) {
      expect(body['Random'] * 2, body['Doubled']);
    });
  });
}
