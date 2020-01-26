library test.jaguar.headers.modified;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/expect/expect.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = http.IOClient();

  group('headers modified', () {
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(
        port: 10000,
        defaultResponseHeaders: (h) {
          h.removeAll('x-frame-options');
          h.add('x-custom', 'value');
        },
      );
      server..get('/empty', (ctx) {});
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('added header', () async {
      await resty
          .get('http://localhost:10000/empty')
          .exact(statusCode: 200, headers: {
        'content-type': 'text/plain; charset=utf-8',
        'x-xss-protection': '1; mode=block',
        'x-content-type-options': 'nosniff',
        'x-custom': 'value',
        'content-length': '0',
      });
    });

    test('removed header', () async {
      await resty.get('http://localhost:10000/empty').expect([
        (r) {
          if (r.headers.containsKey('x-frame-options')) {
            return <Mismatch>[
              new MapHasMismatch(
                'x-frame-options',
                customMessage: (m) => 'Illegal header ${m.key}!',
              )
            ];
          }
          return <Mismatch>[];
        }
      ]);
    });
  });
}
