library example.routes;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
import 'dart:convert';

part 'use_interceptor.g.dart';

@Api(path: '/api')
class ExampleApi {
  final WrapEncodeToJson jsonEncoder = new WrapEncodeToJson();
  final WrapDecodeJsonMap jsonDecoder = new WrapDecodeJsonMap();

  /// A route can be wrapped with interceptors using [InterceptWith] annotation. The
  /// annotation takes list of fields in the controller class that provide [RouteWrapper]s.
  ///
  /// In this case [EncodeToJson] is wrapped around the route.
  @Get(path: '/info')
  @InterceptWith(const [#jsonEncoder])
  Map getJaguarInfo() => {
        'Name': 'Jaguar',
        'Features': ['Speed', 'Simplicity', 'Extensiblity'],
      };

  /// An example showing wrapping multiple interceptors around a route
  @Post(path: '/info')
  @InterceptWith(const [#jsonEncoder, #jsonDecoder])
  Map createJaguarInfo(@Input(DecodeJsonMap) Map body) => body;
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
      Uri uri = new Uri.http('localhost:8080', '/api/info');
      http.Response response = await http.get(uri);
      expect(response.body,
          '{"Name":"Jaguar","Features":["Speed","Simplicity","Extensiblity"]}');
      expect(response.statusCode, 200);
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
    });

    test('two interceptor', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/info');
      http.Response response =
          await http.post(uri, body: JSON.encode({'hello': 'jaguar'}));

      expect(response.body, '{"hello":"jaguar"}');
      expect(response.statusCode, 200);
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
    });
  });
}
