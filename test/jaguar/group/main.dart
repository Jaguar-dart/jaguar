library test.jaguar.group;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

import 'book.dart';

part 'main.g.dart';

@RouteGroup()
class UserApi extends Object with _$JaguarUserApi {
  @Route('', methods: const <String>['GET'])
  String getUser() => 'Get user';

  @Route('/statuscode', methods: const <String>['GET'], statusCode: 201)
  String statusCode() => 'status code';
}

@Api(path: '/api')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Group(path: '/user')
  UserApi user = new UserApi();

  @Group(path: '/book')
  BookApi book = new BookApi();

  @Route('/version', methods: const <String>['GET'])
  String statusCode() => '1.0';
}

void main() {
  group('Group', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new ExampleApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('Route', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/version');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '1.0');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('Group.GET', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'Get user');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('Group.DefaultStatusCode', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user/statuscode');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'status code');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 201);
    });

    test('Group.Imported.GET', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/book');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'Get book');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('Group.POST.StringParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/book/some/param');
      MockHttpRequest rq = new MockHttpRequest(uri, method: 'POST');
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'Some param');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });
  });
}
