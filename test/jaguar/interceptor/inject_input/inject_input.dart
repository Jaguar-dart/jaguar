library test.jaguar.interceptor.inject_request;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

part 'inject_input.g.dart';

class UsesRequest extends Interceptor {
  String pre(Context ctx) => ctx.req.uri.toString();
}

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  static UsesRequest usesRequest(Context ctx) => new UsesRequest();

  @Get(path: '/echo/uri')
  @Wrap(const [usesRequest])
  Response<String> getJaguarInfo(Context ctx) => Response.json({
        'Uri': ctx.getInterceptorResult(UsesRequest),
      });
}

void main() {
  group('Inject Request into interceptor', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new ExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });

  group('Inject Request into interceptor reflected', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(reflect(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });
}

grouped() {
  test('inject request', () async {
    Uri uri = new Uri.http('localhost:8000', '/api/echo/uri');
    http.Response response = await http.get(uri);

    expect(response.statusCode, 200);
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'application/json; charset=utf-8');
    expect(response.body, r'{"Uri":"/api/echo/uri"}');
  });
}
