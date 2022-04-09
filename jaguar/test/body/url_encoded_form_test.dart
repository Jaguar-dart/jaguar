library test.jaguar.body.url_encoded_form;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('body.url_encoded_form', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!.post('/form', (ctx) async {
        Map<String, String> form = await ctx.bodyAsUrlEncodedForm();
        return form['a']! + form['b']!;
      });
      await server!.serve();
    });

    tearDownAll(() async {
      await server?.close();
    });

    test(
        'read',
        () => resty
            .post('http://localhost:$port/form')
            .urlEncodedForm({'a': 'Hello ', 'b': 'world!'}).exact(
                statusCode: 200, mimeType: 'text/plain', body: 'Hello world!'));
    test(
        'correctly decode URI components',
        () => resty
            .post('http://localhost:$port/form')
            .urlEncodedForm({'a': 'It\'s ', 'b': 'Dart and Jaguar(美洲豹)'}).exact(
                statusCode: 200,
                mimeType: 'text/plain',
                body: 'It\'s Dart and Jaguar(美洲豹)'));
  });
}
