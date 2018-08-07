library test.jaguar.data.cookies;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:client_cookie/client_cookie.dart';

void main() {
  resty.globalClient = new http.IOClient();

  group('params.cookies', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
        ..get('/cookie/read', (ctx) {
          return ctx.cookies['user']?.value;
        });
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'read',
        () => resty
            .get('http://localhost:10000/cookie/read')
            .cookie(new ClientCookie('user', 'teja', new DateTime.now()))
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'teja'));
  });
}
