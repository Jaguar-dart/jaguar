library test.jaguar.params.query;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('params.query', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..get('/str', (ctx) => ctx.query['param'])
        ..get('/int', (ctx) => ctx.query.getInt('param', 5)! * 10)
        ..get('/double', (ctx) => ctx.query.getDouble('param', 5.5)! * 10);
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test('string', () async {
      await resty
          .get('http://localhost:$port/str')
          .query('param', 'hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'hello');
    });

    test('int.nondefault', () async {
      await resty
          .get('http://localhost:$port/int')
          .query('param', '2')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '20');
    });

    test('int.default', () async {
      await resty
          .get('http://localhost:$port/int')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '50');
    });

    test('double.nondefault', () async {
      await resty
          .get('http://localhost:$port/double')
          .query('param', '2.2')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '22.0');
    });

    test('double.default', () async {
      await resty
          .get('http://localhost:$port/double')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '55.0');
    });
  });
}
