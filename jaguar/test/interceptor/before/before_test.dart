library test.jaguar.intercept.before;

import 'package:http/io_client.dart' as http;
import 'dart:math';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../../ports.dart' as ports;

final Random rand = Random.secure();

void genRandom(Context ctx) {
  ctx.addVariable(rand.nextInt(1000), id: 'randomInt');
}

void doublesRandom(Context ctx) {
  int randomInt = ctx.getVariable<int>(id: 'randomInt');
  ctx.addVariable(randomInt * 2, id: 'doubledRandomInt');
}

void main() {
  resty.globalClient = http.IOClient();

  group('Custom interceptor:Generated', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..getJson(
            '/two',
            (Context ctx) => {
                  'Random': ctx.getVariable<int>(id: 'randomInt'),
                  'Doubled': ctx.getVariable<int>(id: 'doubledRandomInt'),
                },
            before: [genRandom, doublesRandom]);
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test('one interceptor', () async {
      final body = (await resty
              .get('http://localhost:$port/two')
              .exact(statusCode: 200, mimeType: 'application/json'))
          .json<Map>();
      expect(body['Random'] * 2, body['Doubled']);
    });
  });
}
