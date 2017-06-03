library test.jaguar.interceptor.custom_interceptor;

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'dart:convert';

part 'custom_interceptor.g.dart';

final Random rand = new Random.secure();

class GenRandom extends Interceptor {
  int pre(Context ctx) => rand.nextInt(1000);
}

class UsesRandom extends Interceptor {
  int pre(Context ctx) => ctx.getInput(GenRandom) * 2;
}

@Api(path: '/api')
class ExampleApi {
  GenRandom genRandom(Context ctx) => new GenRandom();

  UsesRandom usesRandom(Context ctx) => new UsesRandom();

  @Get(path: '/random')
  @Wrap(const [#genRandom, #usesRandom])
  Response<String> getRandom(Context ctx) => Response.json({
        'Random': ctx.getInput(GenRandom),
        'Doubled': ctx.getInput(UsesRandom),
      });
}

void main() {
  group('Custom interceptor', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarExampleApi(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('one interceptor', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/random');
      http.Response response = await http.get(uri);

      expect(response.statusCode, 200);
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
      Map body = JSON.decode(response.body);
      expect(body['Random'] * 2, body['Doubled']);
    });
  });
}
