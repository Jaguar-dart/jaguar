library test.jaguar.query_params;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';
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
  @Get(path: '/EncodeJsonable/object')
  @WrapEncodeJsonable()
  Model encodeJsonable_object() => new Model('kleak', 'kleak@kleak.com');

  @Get(path: '/EncodeJsonable/list')
  @WrapEncodeJsonable()
  List<Model> encodeJsonable_list() =>
      <Model>[new Model('kleak', 'kleak@kleak.com')];

  @Get(path: '/EncodeJsonableObject')
  @WrapEncodeJsonableObject()
  Model encodeJsonableObject() => new Model('kleak', 'kleak@kleak.com');

  @Get(path: '/EncodeJsonableList')
  @WrapEncodeJsonableList()
  List<Model> encodeJsonableList() =>
      <Model>[new Model('kleak', 'kleak@kleak.com')];
}

void main() {
  group('Encode ToJsonable', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new JaguarToJsonableExampleApi());
      mock = new JaguarMock(config);
    });

    test('/EncodeJsonable/object', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonable/object');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(
          response.mockContent, '{"name":"kleak","email":"kleak@kleak.com"}');
      expect(
          response.headers.value(HttpHeaders.CONTENT_TYPE), 'application/json');
      expect(response.statusCode, 200);
    });

    test('/EncodeJsonable/list', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonable/list');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(
          response.mockContent, '[{"name":"kleak","email":"kleak@kleak.com"}]');
      expect(
          response.headers.value(HttpHeaders.CONTENT_TYPE), 'application/json');
      expect(response.statusCode, 200);
    });

    test('/EncodeJsonableObject', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonableObject');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(
          response.mockContent, '{"name":"kleak","email":"kleak@kleak.com"}');
      expect(
          response.headers.value(HttpHeaders.CONTENT_TYPE), 'application/json');
      expect(response.statusCode, 200);
    });

    test('/EncodeJsonableList', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/EncodeJsonableList');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(
          response.mockContent, '[{"name":"kleak","email":"kleak@kleak.com"}]');
      expect(
          response.headers.value(HttpHeaders.CONTENT_TYPE), 'application/json');
      expect(response.statusCode, 200);
    });
  });
}
