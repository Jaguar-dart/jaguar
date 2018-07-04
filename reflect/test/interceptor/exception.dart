library test.jaguar.intercept.exception;

import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

final Random rand = new Random.secure();

void handleException(Context ctx, e, s) => throw Response('exception');

@Controller()
class ExampleController {
  @Get(path: '/except')
  @OnException(const [handleException])
  void one(Context ctx) => throw new Exception();
}

void main() {
  resty.globalClient = new http.IOClient();

  group('OnException', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server..add(reflect(new ExampleController()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'trigger',
        () => resty
            .get('/except')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'exception'));
  });
}
