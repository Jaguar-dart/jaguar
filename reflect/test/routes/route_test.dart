library test.jaguar.routes;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@GenController(path: "/api")
class ExampleController extends Controller {
  @Get(path: '/get')
  String get(_) => 'Get';
}

void main() {
  resty.globalClient = http.IOClient();

  group('routes', () {
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(port: 10000);
      server.add(reflect(ExampleController()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Get', () async {
      await resty
          .get('http://localhost:10000/api/get')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'Get');
    });
  });
}
