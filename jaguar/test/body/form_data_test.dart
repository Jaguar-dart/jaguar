library test.jaguar.body.form_data;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:http_parser/http_parser.dart';
import '../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('body.form_data', () {
    final port = ports.random;
    Jaguar? server;
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server!.post('/form', (ctx) async {
        Map<String, FormField> form = await ctx.bodyAsFormData();

        final string = form['string'] as StringFormField;
        final binary = form['binary'] as BinaryFileFormField;
        final text = form['text']! as TextFileFormField;

        List<int> binaryData = (await binary.value.toList())
            .fold(<int>[], (List<int> a, List<int> b) => a..addAll(b));

        String textData = await text.value.first;

        return "${string.value}${binaryData[0]}${binaryData[1]}${textData}";
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
