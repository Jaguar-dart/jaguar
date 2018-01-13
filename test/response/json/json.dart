library test.jaguar.response.json;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'json.g.dart';

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  @Get(path: '/info')
  Response<String> getJaguarInfo(Context ctx) => Response.json({
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      });

  @Post(path: '/info')
  Response<String> createJaguarInfo(Context ctx) => Response.json([1, 2, 3]);
}

void main() {
  group('JSON response', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new ExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('render json Map', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/info');
      http.Response response = await http.get(uri);
      expect(response.body,
          '{"Name":"Jaguar","Features":["Speed","Simplicity","Extensiblity"]}');
      expect(response.statusCode, 200);
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
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
