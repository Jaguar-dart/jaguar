library test.jaguar.query_params;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'query_params.g.dart';

@Api(path: '/api')
class QueryParamsExampleApi extends _$JaguarQueryParamsExampleApi {
  @Get(path: '/stringParam')
  String stringParam(Context ctx) => ctx.query['strParam'];

  @Get(path: '/intParam')
  String intParam(Context ctx) =>
      '${ctx.query.getInt('intParam')*ctx.query.getInt('intParam')}';

  @Get(path: '/doubleParam')
  String doubleParam(Context ctx) => '${ctx.query.getDouble('doubleParam')*2}';

  @Get(path: '/numParam')
  String numParam(Context ctx) => '${ctx.query.getNum('numParam')*2}';

  @Get(path: '/defStringParam')
  String defStringParam(Context ctx) => ctx.query.get('strParam', 'default');

  @Get(path: '/defIntParam')
  String defIntParam(Context ctx) =>
      '${ctx.query.getInt('intParam', 50)*ctx.query.getInt('intParam', 50)}';

  @Get(path: '/defDoubleParam')
  String defDoubleParam(Context ctx) =>
      '${ctx.query.getDouble('doubleParam', 12.75)*2}';

  @Get(path: '/defNumParam')
  String defDumParam(Context ctx) => '${ctx.query.getNum('numParam', 5.25)*2}';
}

void main() {
  group('route', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new QueryParamsExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('stringParam', () async {
      Uri uri = new Uri.http(
          'localhost:8000', '/api/stringParam', {'strParam': 'hello'});
      http.Response response = await http.get(uri);

      expect(response.body, 'hello');
      expect(response.statusCode, 200);
    });

    test('intParam', () async {
      Uri uri =
          new Uri.http('localhost:8000', '/api/intParam', {'intParam': '5'});
      http.Response response = await http.get(uri);

      expect(response.body, '25');
      expect(response.statusCode, 200);
    });

    test('doubleParam', () async {
      Uri uri = new Uri.http(
          'localhost:8000', '/api/doubleParam', {'doubleParam': '1.25'});
      http.Response response = await http.get(uri);

      expect(response.body, '2.5');
      expect(response.statusCode, 200);
    });

    test('numParam', () async {
      Uri uri =
          new Uri.http('localhost:8000', '/api/numParam', {'numParam': '1.25'});
      http.Response response = await http.get(uri);

      expect(response.body, '2.5');
      expect(response.statusCode, 200);
    });

    test('defStringParam', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/defStringParam');
      http.Response response = await http.get(uri);

      expect(response.body, 'default');
      expect(response.statusCode, 200);
    });

    test('defIntParam', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/defIntParam');
      http.Response response = await http.get(uri);

      expect(response.body, '2500');
      expect(response.statusCode, 200);
    });

    test('defDoubleParam', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/defDoubleParam');
      http.Response response = await http.get(uri);

      expect(response.body, '25.5');
      expect(response.statusCode, 200);
    });

    test('defNumParam', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/defNumParam');
      http.Response response = await http.get(uri);

      expect(response.body, '10.5');
      expect(response.statusCode, 200);
    });
  });
}
