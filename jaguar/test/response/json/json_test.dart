library test.jaguar.response.json;

import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

class _Info {
  String name;

  List<String> motto;

  _Info(this.name, this.motto);

  Map<String, dynamic> toJson() => {
        'name': name,
        'motto': motto,
      };
}

void main() {
  resty.globalClient = new http.IOClient();

  group('Response.Json', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
        ..getJson(
            '/response_processor/podo',
            (Context ctx) =>
                new _Info('Jaguar', ['Speed', 'Simplicity', 'Extensiblity']))
        ..getJson('/response_processor/nums', (Context ctx) => <int>[1, 2, 3])
        ..get(
            '/strresponse/podo',
            (Context ctx) => Response.json(
                new _Info('Jaguar', ['Speed', 'Simplicity', 'Extensiblity'])))
        ..get('/strresponse/nums',
            (Context ctx) => Response.json(<int>[1, 2, 3]));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('ResponseProcessor.Podo', () async {
      await resty.get('http://localhost:10000/response_processor/podo').exact(
          statusCode: 200,
          mimeType: MimeTypes.json,
          body:
              r'{"name":"Jaguar","motto":["Speed","Simplicity","Extensiblity"]}');
    });

    test('ResponseProcessor.List', () async {
      await resty
          .get('http://localhost:10000/response_processor/nums')
          .exact(statusCode: 200, mimeType: MimeTypes.json, body: '[1,2,3]');
    });

    test('StrResponse.Podo', () async {
      await resty.get('http://localhost:10000/strresponse/podo').exact(
          statusCode: 200,
          mimeType: MimeTypes.json,
          body:
              r'{"name":"Jaguar","motto":["Speed","Simplicity","Extensiblity"]}');
    });

    test('StrResponse.List', () async {
      await resty
          .get('http://localhost:10000/strresponse/nums')
          .exact(statusCode: 200, mimeType: MimeTypes.json, body: '[1,2,3]');
    });
  });
}
