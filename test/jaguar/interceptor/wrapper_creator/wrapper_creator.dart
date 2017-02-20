library test.jaguar.interceptor.wrapper_creator;

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'dart:convert';

part 'wrapper_creator.g.dart';

final Random rand = new Random.secure();

class WrapGenRandom extends RouteWrapper<GenRandom> {
  GenRandom createInterceptor() => new GenRandom();
}

class GenRandom extends Interceptor {
  int pre() => rand.nextInt(1000);
}

class WrapUsesRandom extends RouteWrapper<UsesRandom> {
  final int random;

  const WrapUsesRandom(this.random);

  UsesRandom createInterceptor() => new UsesRandom(random);
}

class UsesRandom extends Interceptor {
  final int random;

  UsesRandom(this.random);

  int pre() => random * 2;
}

@Api(path: '/api')
class ExampleApi {
  WrapGenRandom genRandom() => new WrapGenRandom();

  WrapUsesRandom usesRandom(@Input(GenRandom) int random) =>
      new WrapUsesRandom(random);

  WrapEncodeToJson jsonEncoder() => new WrapEncodeToJson();

  @Get(path: '/random')
  @Wrap(const [#jsonEncoder, #genRandom, #usesRandom])
  Map getRandom(@Input(GenRandom) int random, @Input(UsesRandom) int doubled) =>
      {
        'Random': random,
        'Doubled': doubled,
      };
}

void main() {
  group('Wrapper creator', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Inject interceptor output', () async {
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
