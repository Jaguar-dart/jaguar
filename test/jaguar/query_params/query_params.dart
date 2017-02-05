library test.jaguar.query_params;

import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'query_params.g.dart';

@Api(path: '/api')
class QueryParamsExampleApi {
  @Get(path: '/stringParam')
  String stringParam({String strParam}) => strParam;

  @Get(path: '/intParam')
  String intParam({int intParam}) => '${intParam*intParam}';

  @Get(path: '/doubleParam')
  String doubleParam({num doubleParam}) => '${doubleParam*2}';

  @Get(path: '/numParam')
  String numParam({num numParam}) => '${numParam*2}';

  @Get(path: '/defStringParam')
  String defStringParam({String strParam: 'default'}) => strParam;

  @Get(path: '/defIntParam')
  String defIntParam({int intParam: 50}) => '${intParam*intParam}';

  @Get(path: '/defDoubleParam')
  String defDoubleParam({num doubleParam: 12.75}) => '${doubleParam*2}';

  @Get(path: '/defNumParam')
  String defDumParam({num numParam: 5.25}) => '${numParam*2}';
}

void main() {
  group('route', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new JaguarQueryParamsExampleApi());
      mock = new JaguarMock(config);
    });

    test('stringParam', () async {
      Uri uri = new Uri.http(
          'localhost:8080', '/api/stringParam', {'strParam': 'hello'});
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'hello');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('intParam', () async {
      Uri uri =
          new Uri.http('localhost:8080', '/api/intParam', {'intParam': '5'});
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '25');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('doubleParam', () async {
      Uri uri = new Uri.http(
          'localhost:8080', '/api/doubleParam', {'doubleParam': '1.25'});
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '2.5');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('numParam', () async {
      Uri uri =
          new Uri.http('localhost:8080', '/api/numParam', {'numParam': '1.25'});
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '2.5');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('defStringParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defStringParam');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'default');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('defIntParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defIntParam');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '2500');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('defDoubleParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defDoubleParam');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '25.5');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('defNumParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defNumParam');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '10.5');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });
  });
}
