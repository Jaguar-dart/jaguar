library test.jaguar.respose.empty;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = http.IOClient();

  group('response', () {
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(port: 10000);
      server..get('/empty', (ctx) {});
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('empty', () async {
      await resty
          .get('http://localhost:10000/empty')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '');
    });
  });
}
