library test.jaguar.serve.restart;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = http.IOClient();

  group('mux', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server..get('/hello', (ctx) => 'Hello world!');
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Server.Restart', () async {
      await resty
          .get('http://localhost:10000/hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello world!');
      await server.restart();
      await resty
          .get('http://localhost:10000/hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello world!');
    });
  });
}
