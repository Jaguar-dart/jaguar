library test.jaguar.intercept.exception;

import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

final Random rand = new Random.secure();

void handleException(Context ctx, e, s) {
  throw Response('exception');
}

void main() {
  resty.globalClient = new http.IOClient();

  group('OnException', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
        ..get('/except', (Context ctx) => throw new Exception(),
            onException: [handleException]);
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'trigger',
        () => resty
            .get('http://localhost:10000/except')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'exception'));
  });
}
