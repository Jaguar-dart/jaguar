library test.jaguar.response.json;

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
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

@Api(path: '/api')
class ExampleApi {
  @GetJson(path: '/info')
  _Info getJaguarInfo(Context ctx) =>
      new _Info('Jaguar', ['Speed', 'Simplicity', 'Extensiblity']);

  @GetJson(path: '/nums')
  List<int> createJaguarInfo(Context ctx) => <int>[1, 2, 3];
}

void main() {
  resty.globalClient = new http.IOClient();

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

    test('EncodeJsonPodo', () async {
      await resty.get('/api/info').authority('http://localhost:8000').exact(
          statusCode: 200,
          mimeType: MimeType.json,
          body:
              r'{"name":"Jaguar","motto":["Speed","Simplicity","Extensiblity"]}');
    });

    test('EncodeJsonList', () async {
      await resty
          .get('/api/nums')
          .authority('http://localhost:8000')
          .exact(statusCode: 200, mimeType: MimeType.json, body: '[1,2,3]');
    });
  });
}
