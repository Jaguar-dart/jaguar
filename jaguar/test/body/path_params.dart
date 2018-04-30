library test.jaguar.params.path;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = new http.IOClient();

  group('params.path', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
        ..get('/str/:id', (ctx) => ctx.pathParams['id'])
        ..get('/int/:id', (ctx) => ctx.pathParams.getInt('id', 5) * 10)
        ..get('/double/:id',
            (ctx) => ctx.pathParams.getDouble('id', 5.5) * 10);
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('string', () async {
      await resty
          .get('/str/hello')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'hello');
    });

    test('int.nondefault', () async {
      await resty
          .get('/int/2')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '20');
    });

    test('int.default', () async {
      await resty
          .get('/int/boom')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '50');
    });

    test('double.nondefault', () async {
      await resty
          .get('/double/2.2')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '22.0');
    });

    test('double.default', () async {
      await resty
          .get('/double/boom')
          .authority('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '55.0');
    });
  });
}
