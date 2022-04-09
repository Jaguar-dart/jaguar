library test.jaguar.serve.restart;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('Restart', () {
    final port = ports.random;
    Jaguar server = Jaguar();
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server..get('/hello', (ctx) => 'Hello world!');
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Server.Restart', () async {
      await resty
          .get('http://localhost:$port/hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello world!');
      await server.restart();
      await resty
          .get('http://localhost:$port/hello')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello world!');
    });
  });
}
