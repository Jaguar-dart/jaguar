library test.jaguar.group;

import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

import 'book.dart';

part 'main.g.dart';

@Api()
class UserApi extends _$JaguarUserApi {
  @Route(methods: const <String>['GET'])
  String getUser(Context ctx) => 'Get user';

  @Route(path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  String statusCode(Context ctx) => 'status code';
}

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  @IncludeApi(path: '/user')
  final UserApi user = new UserApi();

  @IncludeApi(path: '/book')
  final BookApi book = new BookApi();

  @Route(path: '/version', methods: const <String>['GET'])
  String statusCode(Context ctx) => '1.0';
}

void main() {
  group('Group', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new ExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });

  group('Group reflected', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(reflect(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    grouped();
  });
}

grouped() {
  test(
      'Route',
      () => resty
          .get('/api/version')
          .authority('http://localhost:8000')
          .exact(statusCode: 200, body: '1.0'));

  test(
      'Group.GET',
      () => resty
          .get('/api/user')
          .authority('http://localhost:8000')
          .exact(statusCode: 200, body: 'Get user'));

  test(
      'Group.DefaultStatusCode',
      () => resty
          .get('/api/user/statuscode')
          .authority('http://localhost:8000')
          .exact(statusCode: 201, body: 'status code'));

  test(
      'Group.Imported.GET',
      () => resty
          .get('/api/book')
          .authority('http://localhost:8000')
          .exact(statusCode: 200, body: 'Get book'));

  test(
      'Group.POST.StringParam',
      () => resty
          .post('/api/book/some/param')
          .authority('http://localhost:8000')
          .exact(statusCode: 200, body: 'Some param'));
}
