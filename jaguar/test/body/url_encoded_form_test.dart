library test.jaguar.body.url_encoded_form;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = new http.IOClient();

  group('body.url_encoded_form', () {
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(port: 10000);
      server.post('/form', (ctx) async {
        Map<String, String> form = await ctx.bodyAsUrlEncodedForm();
        return form['a'] + form['b'];
      });
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'read',
        () => resty
            .post('http://localhost:10000/form')
            .urlEncodedForm({'a': 'Hello ', 'b': 'world!'}).exact(
                statusCode: 200, mimeType: 'text/plain', body: 'Hello world!'));
    test(
        'correctly decode URI components',
        () => resty
            .post('http://localhost:10000/form')
            .urlEncodedForm({'a': 'It\'s ', 'b': 'Dart and Jaguar(美洲豹)'}).exact(
                statusCode: 200,
                mimeType: 'text/plain',
                body: 'It\'s Dart and Jaguar(美洲豹)'));
  });
}
