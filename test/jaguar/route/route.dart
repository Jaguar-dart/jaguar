library test.jaguar.route;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'route.g.dart';

@Api(path: '/api')
class ExampleApi {
  @Route(path: '/user', methods: const <String>['GET'])
  String getUser(Context ctx) => 'Get user';

  @Get(path: '/statuscode', statusCode: 201)
  String statusCode(Context ctx) => 'status code';

  @Get(path: '/paramandquery/:param')
  String paramAndQuery(Context ctx) =>
      '${ctx.pathParams['param']} ${ctx.queryParams['query']}';

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
      server = new Jaguar();
      server.addApi(new JaguarExampleApi(new ExampleApi()));
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
      server = new Jaguar();
      server.addApiReflected(new ExampleApi());
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
    Uri uri = new Uri.http('localhost:8080', '/api/user');
    http.Response response = await http.get(uri);

    print(response.body);
    expect(response.statusCode, 200);
    expect(response.body, 'Get user');
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'text/plain; charset=utf-8');
  });

  test('DefaultStatusCode', () async {
    Uri uri = new Uri.http('localhost:8080', '/api/statuscode');
    http.Response response = await http.get(uri);

    expect(response.body, 'status code');
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'text/plain; charset=utf-8');
    expect(response.statusCode, 201);
  });

  test('ParamAndQuery', () async {
    Uri uri = new Uri.http(
        'localhost:8080', '/api/paramandquery/hello', {'query': 'world'});
    http.Response response = await http.get(uri);

    expect(response.body, 'hello world');
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'text/plain; charset=utf-8');
    expect(response.statusCode, 200);
  });

  test('InputHeader', () async {
    Uri uri = new Uri.http('localhost:8080', '/api/input/header');
    http.Response response = await http.get(uri, headers: {'user': 'teja'});

    expect(response.body, 'teja');
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'text/plain; charset=utf-8');
    expect(response.statusCode, 200);
  });

  test('InputHeaders', () async {
    Uri uri = new Uri.http('localhost:8080', '/api/input/headers');
    http.Response response = await http.get(uri, headers: {'user': 'kleak'});

    expect(response.body, 'kleak');
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'text/plain; charset=utf-8');
    expect(response.statusCode, 200);
  });

  test('InputCookie', () async {
    Uri uri = new Uri.http('localhost:8080', '/api/input/cookie');
    http.Response response =
        await http.get(uri, headers: {'cookie': 'user=teja'});

    expect(response.body, 'teja');
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'text/plain; charset=utf-8');
    expect(response.statusCode, 200);
  });

  test('InputCookies', () async {
    Uri uri = new Uri.http('localhost:8080', '/api/input/cookies');
    http.Response response =
        await http.get(uri, headers: {'cookie': 'user=kleak'});

    expect(response.body, 'kleak');
    expect(response.headers[HttpHeaders.CONTENT_TYPE],
        'text/plain; charset=utf-8');
    expect(response.statusCode, 200);
  });
}
