library test.bind.routes;

import 'package:http/io_client.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/bind.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

@GenController(path: "/api")
class ExampleController extends Controller {
  @Get(path: '/get')
  String get() => 'Get';

  @Get(path: '/path/:id')
  String pathParameter(@bindPath String id) => id;

  @Get(path: '/path/int/:id')
  int pathParameterInt(@bindPath int id) => id;

  @Get(path: '/path/onsite/:id')
  String pathParameterOnsite(String id) => id;
}

void main() {
  resty.globalClient = http.IOClient();

  group('bind', () {
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

    test('Path parameter', () async {
      await resty
          .get('http://localhost:10000/api/path/1234')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '1234');
    });

    test('Path parameter int', () async {
      await resty
          .get('http://localhost:10000/api/path/int/1234')
          .exact(statusCode: 200, mimeType: 'text/plain', body: '1234');
    });

    group('onsite', () {
      test('parameter', () async {
        await resty
            .get('http://localhost:10000/api/path/onsite/1234')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '1234');
      });
    });
  });
}
