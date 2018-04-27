library test.jaguar.interceptor.custom_interceptor;

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

part 'custom_interceptor.g.dart';

final Random rand = new Random.secure();

void genRandom(Context ctx) {
  ctx.addVariable(rand.nextInt(1000), id: 'randomInt');
}

void doublesRandom(Context ctx) {
  int randomInt = ctx.getVariable<int>(id: 'randomInt');
  ctx.addVariable(randomInt * 2, id: 'doubledRandomInt');
}

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  @Get(path: '/random')
  @Intercept(const [genRandom, doublesRandom])
  Response<String> getRandom(Context ctx) => Response.json({
        'Random': ctx.getVariable<int>(id: 'randomInt'),
        'Doubled': ctx.getVariable<int>(id: 'doubledRandomInt'),
      });
}

void main() {
  resty.globalClient = new http.IOClient();

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
