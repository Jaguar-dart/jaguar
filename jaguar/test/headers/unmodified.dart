library test.jaguar.headers.unmodified;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = http.IOClient();

  group('headers unmodified', () {
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(port: 10000);
      server..get('/empty', (ctx) {});
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('default', () async {
      await resty
          .get('http://localhost:10000/empty')
          .exact(statusCode: 200, headers: {
        'x-frame-options': 'SAMEORIGIN',
        'content-type': 'text/plain; charset=utf-8',
        'x-xss-protection': '1; mode=block',
        'x-content-type-options': 'nosniff',
        'content-length': '0',
      });
    });
  });
}
