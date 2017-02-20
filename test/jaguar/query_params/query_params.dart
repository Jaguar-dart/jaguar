library test.jaguar.query_params;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

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
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarQueryParamsExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('stringParam', () async {
      Uri uri = new Uri.http(
          'localhost:8080', '/api/stringParam', {'strParam': 'hello'});
      http.Response response = await http.get(uri);

      expect(response.body, 'hello');
      expect(response.statusCode, 200);
    });

    test('intParam', () async {
      Uri uri =
          new Uri.http('localhost:8080', '/api/intParam', {'intParam': '5'});
      http.Response response = await http.get(uri);

      expect(response.body, '25');
      expect(response.statusCode, 200);
    });

    test('doubleParam', () async {
      Uri uri = new Uri.http(
          'localhost:8080', '/api/doubleParam', {'doubleParam': '1.25'});
      http.Response response = await http.get(uri);

      expect(response.body, '2.5');
      expect(response.statusCode, 200);
    });

    test('numParam', () async {
      Uri uri =
          new Uri.http('localhost:8080', '/api/numParam', {'numParam': '1.25'});
      http.Response response = await http.get(uri);

      expect(response.body, '2.5');
      expect(response.statusCode, 200);
    });

    test('defStringParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defStringParam');
      http.Response response = await http.get(uri);

      expect(response.body, 'default');
      expect(response.statusCode, 200);
    });

    test('defIntParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defIntParam');
      http.Response response = await http.get(uri);

      expect(response.body, '2500');
      expect(response.statusCode, 200);
    });

    test('defDoubleParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defDoubleParam');
      http.Response response = await http.get(uri);

      expect(response.body, '25.5');
      expect(response.statusCode, 200);
    });

    test('defNumParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/defNumParam');
      http.Response response = await http.get(uri);

      expect(response.body, '10.5');
      expect(response.statusCode, 200);
    });
  });
}
