library test.jaguar.response.json;

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

@Api(path: '/api')
class ExampleApi {
  @GetJson(path: '/info')
  Map getJaguarInfo(Context ctx) => {
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      };

  @PostJson(path: '/info')
  List<int> createJaguarInfo(Context ctx) => <int>[1, 2, 3];
}

void main() {
  group('JSON response', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(reflect(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('render json Map', () async {
      await resty.get('/api/info').authority('http://localhost:8080').expect([
        resty.statusCodeIs(200),
        resty.contentTypeIsJson,
        resty.bodyIs(
            '{"Name":"Jaguar","Features":["Speed","Simplicity","Extensiblity"]}')
      ]);
    });

    test('Render json List', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/info');
      http.Response response = await http.post(uri);

      expect(response.body, '[1,2,3]');
      expect(response.statusCode, 200);
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
    });
  });
}
