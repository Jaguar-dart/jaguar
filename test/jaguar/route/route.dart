library test.jaguar.route;

import 'dart:io';
import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:http/http.dart' as http;

part 'route.g.dart';

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  @Route(path: '/user', methods: const <String>['GET'])
  String getUser(Context ctx) => 'Get user';

  @Get(path: '/statuscode', statusCode: 201)
  String statusCode(Context ctx) => 'status code';

  @Get(path: '/paramandquery/:param')
  String paramAndQuery(Context ctx) =>
      '${ctx.pathParams['param']} ${ctx.query['query']}';

  @Get(path: '/input/header')
  String inputHeader(Context ctx) => ctx.req.headers.value('user');

  @Get(path: '/input/headers')
  String inputHeaders(Context ctx) {
    HttpHeaders headers = ctx.req.headers;
    return headers.value('user');
  }

  @Get(path: '/input/cookie')
  String inputCookie(Context ctx) =>
      ctx.req.cookies.firstWhere((Cookie c) => c.name == 'user')?.value;

  @Get(path: '/input/cookies')
  String inputCookies(Context ctx) {
    List<Cookie> cookies = ctx.req.cookies;
    return cookies.firstWhere((Cookie cook) => cook.name == 'user')?.value;
  }
}

void main() {
  group('route', () {
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

  group('route reflected', () {
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
  test('GET', () async {
    await resty
        .get('/api/user')
        .authority('http://localhost:8000')
        .exact(statusCode: 200, mimeType: 'text/plain', body: 'Get user');
  });

  test('DefaultStatusCode', () async {
    await resty
        .get('/api/statuscode')
        .authority('http://localhost:8000')
        .exact(statusCode: 201, mimeType: 'text/plain', body: 'status code');
  });

  test('ParamAndQuery', () async {
    await resty
        .get('/api/paramandquery/hello')
        .authority('http://localhost:8000')
        .query('query', 'world')
        .exact(statusCode: 200, mimeType: 'text/plain', body: 'hello world');
  });

  test('InputHeader', () async {
    await resty
        .get('/api/input/header')
        .authority('http://localhost:8000')
        .header('user', 'teja')
        .exact(statusCode: 200, mimeType: 'text/plain', body: 'teja');
  });

  test('InputCookie', () async {
    await resty
        .get('/api/input/cookie')
        .authority('http://localhost:8000')
        .header('cookie', 'user=teja')
        .exact(statusCode: 200, mimeType: 'text/plain', body: 'teja');
  });
}
