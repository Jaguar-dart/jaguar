library test.jaguar.params.path;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('params.path', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..get('/str/:id', (ctx) => ctx.pathParams['id'])
        ..get('/int/:id', (ctx) => ctx.pathParams.getInt('id', 5)! * 10)
        ..get(
            '/double/:id', (ctx) => ctx.pathParams.getDouble('id', 5.5)! * 10);
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test('string', () async {
      await resty
          .get('http://localhost:$port/str/hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'hello');
    });

    test('int.nondefault', () async {
      await resty
          .get('http://localhost:$port/int/2')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '20');
    });

    test('int.default', () async {
      await resty
          .get('http://localhost:$port/int/boom')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '50');
    });

    test('double.nondefault', () async {
      await resty
          .get('http://localhost:$port/double/2.2')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '22.0');
    });

    test('double.default', () async {
      await resty
          .get('http://localhost:$port/double/boom')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '55.0');
    });
  });
}
