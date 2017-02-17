library example.routes;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'dart:convert';

part 'inject_request.g.dart';

class WrapUsesRequest extends RouteWrapper<UsesRequest> {
  UsesRequest createInterceptor() => new UsesRequest();
}

class UsesRequest extends Interceptor {
  String pre(Request req) => req.uri.toString();
}

@Api(path: '/api')
class ExampleApi {
  WrapUsesRequest usesRequest() => new WrapUsesRequest();

  WrapEncodeToJson jsonEncoder() => new WrapEncodeToJson();

  @Get(path: '/echo/uri')
  @InterceptWith(const [#jsonEncoder, #usesRequest])
  Map getJaguarInfo(@Input(UsesRequest) String uri) => {
        'Uri': uri,
      };
}

void main() {
  group('use_interceptor', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('one interceptor', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/echo/uri');
      http.Response response = await http.get(uri);

      expect(response.statusCode, 200);
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
      expect(response.body, r'{"Uri":"/api/echo/uri"}');
    });
  });
}
