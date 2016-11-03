library test.jaguar.route;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'route.g.dart';

@Api(path: '/api')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route('/user', methods: const <String>['GET'])
  String getUser() => 'Get user';

  @Route('/statuscode', methods: const <String>['GET'], statusCode: 201)
  String statusCode() => 'status code';
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
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('DefaultStatusCode', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/statuscode');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'status code');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 201);
    });
  });
}
