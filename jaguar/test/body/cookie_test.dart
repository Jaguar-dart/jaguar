library test.jaguar.data.cookies;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:client_cookie/client_cookie.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('params.cookies', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!
        ..get('/cookie/read', (ctx) {
          return ctx.cookies['user']?.value;
        });
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test(
        'read',
        () => resty
            .get('http://localhost:$port/cookie/read')
            .cookie(ClientCookie('user', 'teja', DateTime.now()))
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'teja'));
  });
}
