library test.jaguar.query_params;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';

part 'tojsonable.g.dart';

class Model implements ToJsonable {
  Model(this.name, this.email);

  String name = "";

  String email = "";

  Map toJson() => {
        "name": name,
        "email": email,
      };
}

@Api(path: '/api')
class ToJsonableExampleApi {
  final WrapEncodeJsonable jsonEncoder = new WrapEncodeJsonable();
  @Get(path: '/EncodeJsonable/object')
  @InterceptWith(const [#jsonEncoder])
  Model encodeJsonable_object() => new Model('kleak', 'kleak@kleak.com');

  @Get(path: '/EncodeJsonable/list')
  @InterceptWith(const [#jsonEncoder])
  List<Model> encodeJsonable_list() =>
      <Model>[new Model('kleak', 'kleak@kleak.com')];

  @Get(path: '/EncodeJsonableObject')
  @InterceptWith(const [#jsonEncoder])
  Model encodeJsonableObject() => new Model('kleak', 'kleak@kleak.com');

  @Get(path: '/EncodeJsonableList')
  @InterceptWith(const [#jsonEncoder])
  List<Model> encodeJsonableList() =>
      <Model>[new Model('kleak', 'kleak@kleak.com')];
}

void main() {
  group('Encode ToJsonable', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarToJsonableExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('/EncodeJsonable/object', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonable/object');
      http.Response response = await http.get(uri);

      expect(response.body, '{"name":"kleak","email":"kleak@kleak.com"}');
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
      expect(response.statusCode, 200);
    });

    test('/EncodeJsonable/list', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonable/list');
      http.Response response = await http.get(uri);

      expect(response.body, '[{"name":"kleak","email":"kleak@kleak.com"}]');
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
      expect(response.statusCode, 200);
    });

    test('/EncodeJsonableObject', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonableObject');
      http.Response response = await http.get(uri);

      expect(response.body, '{"name":"kleak","email":"kleak@kleak.com"}');
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
      expect(response.statusCode, 200);
    });

    test('/EncodeJsonableList', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonableList');
      http.Response response = await http.get(uri);

      expect(response.body, '[{"name":"kleak","email":"kleak@kleak.com"}]');
      expect(response.headers[HttpHeaders.CONTENT_TYPE],
          'application/json; charset=utf-8');
      expect(response.statusCode, 200);
    });
  });
}
