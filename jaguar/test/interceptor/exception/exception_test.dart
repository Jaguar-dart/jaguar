library test.jaguar.intercept.exception;

import 'package:http/io_client.dart' as http;
import 'dart:math';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../../ports.dart' as ports;

final Random rand = Random.secure();

Response handleException(Context ctx, e, s) =>
    ctx.response = Response(body: 'exception');

void main() {
  resty.globalClient = http.IOClient();

  group('OnException', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..get('/except', (Context ctx) => throw Exception(),
            onException: [handleException]);
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test(
        'trigger',
        () => resty
            .get('http://localhost:$port/except')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'exception'));
  });
}
