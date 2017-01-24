library test.jaguar.route;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'route.g.dart';

@Api(path: '/api')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route(path: '/user', methods: const <String>['GET'])
  String getUser() => 'Get user';

  @Route(path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  String statusCode() => 'status code';

  @Route(path: '/paramandquery/:param', methods: const <String>['GET'])
  String paramAndQuery(String param, {String query}) => '$param $query';

  @Route(path: '/input/header', methods: const <String>['GET'])
  @InputHeader('user')
  String inputHeader(String user) => user;

  @Route(path: '/input/headers', methods: const <String>['GET'])
  @InputHeaders()
  String inputHeaders(HttpHeaders headers) {
    return headers.value('user');
  }

  @Route(path: '/input/cookie', methods: const <String>['GET'])
  @InputCookie('user')
  String inputCookie(String user) => user;

  @Route(path: '/input/cookies', methods: const <String>['GET'])
  @InputCookies()
  String inputCookies(List<Cookie> cookies) {
    return cookies.firstWhere((Cookie cook) => cook.name == 'user')?.value;
  }
}

void main() {
  group('route', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new ExampleApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('GET', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'Get user');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('DefaultStatusCode', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/statuscode');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'status code');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 201);
    });

    test('ParamAndQuery', () async {
      Uri uri = new Uri.http(
          'localhost:8080', '/api/paramandquery/hello', {'query': 'world'});
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'hello world');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('InputHeader', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/input/header');
      MockHttpHeaders headers = new MockHttpHeaders();
      headers.set('user', 'teja');
      MockHttpRequest rq = new MockHttpRequest(uri, header: headers);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'teja');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('InputHeaders', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/input/headers');
      MockHttpHeaders headers = new MockHttpHeaders();
      headers.set('user', 'kleak');
      MockHttpRequest rq = new MockHttpRequest(uri, header: headers);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'kleak');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('InputCookie', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/input/cookie');
      MockHttpHeaders headers = new MockHttpHeaders();
      headers.set('cookie', 'user=teja');

      MockHttpRequest rq = new MockHttpRequest(uri, header: headers);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'teja');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('InputCookies', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/input/cookies');
      MockHttpHeaders headers = new MockHttpHeaders();
      headers.set('cookie', 'user=kleak');
      MockHttpRequest rq = new MockHttpRequest(uri, header: headers);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'kleak');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });
  });
}
