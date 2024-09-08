library test.jaguar.respose.empty;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('response', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!..get('/empty', (ctx) {});
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test('empty', () async {
      await resty
          .get('http://localhost:$port/empty')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '');
    });
  });
}
