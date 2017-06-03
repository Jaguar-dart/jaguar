library test.jaguar.interceptor.inject_request;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'inject_request.g.dart';

class UsesRequest extends Interceptor {
  String pre(Context ctx) => ctx.req.uri.toString();
}

@Api(path: '/api')
class ExampleApi {
  UsesRequest usesRequest(Context ctx) => new UsesRequest();

  @Get(path: '/echo/uri')
  @Wrap(const [#usesRequest])
  Response<String> getJaguarInfo(Context ctx) => Response.json({
        'Uri': ctx.getInput(UsesRequest),
      });
}

void main() {
  group('Inject Request into interceptor', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarExampleApi(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('inject request', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/echo/uri');
      http.Response response = await http.get(uri);

      expect(response.statusCode, 200);
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
      expect(response.body, r'{"Uri":"/api/echo/uri"}');
    });
  });
}
