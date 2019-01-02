library test.jaguar.body.form_data;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:http_parser/http_parser.dart';

void main() {
  resty.globalClient = new http.IOClient();

  group('body.form_data', () {
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(port: 10000);
      server.post('/form', (ctx) async {
        Map<String, FormField> form = await ctx.bodyAsFormData();

        StringFormField string = form['string'];
        BinaryFileFormField binary = form['binary'];
        TextFileFormField text = form['text'];

        List<int> binaryData = (await binary.value.toList())
            .fold([], (List a, List b) => a..addAll(b));

        String textData = await text.value.first;

        return "${string.value}${binaryData[0]}${binaryData[1]}${textData}";
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
            .multipart({'string': 'Hello '})
            .multipartFile('binary', [1, 2])
            .multipartStringFile('text', "Hello world!",
                filename: 'text.txt',
                contentType: MediaType('application', 'json'))
            .exact(
                statusCode: 200,
                mimeType: 'text/plain',
                body: 'Hello 12Hello world!'));
  });
}
