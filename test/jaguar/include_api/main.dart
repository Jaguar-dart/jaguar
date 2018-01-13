library test.jaguar.group;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

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
  test('Route', () async {
    Uri uri = new Uri.http('localhost:8000', '/api/version');
    http.Response response = await http.get(uri);

    expect(response.body, '1.0');
    expect(response.statusCode, 200);
  });

  test('Group.GET', () async {
    Uri uri = new Uri.http('localhost:8000', '/api/user');
    http.Response response = await http.get(uri);

    expect(response.body, 'Get user');
    expect(response.statusCode, 200);
  });

  test('Group.DefaultStatusCode', () async {
    Uri uri = new Uri.http('localhost:8000', '/api/user/statuscode');
    http.Response response = await http.get(uri);

    expect(response.body, 'status code');
    expect(response.statusCode, 201);
  });

  test('Group.Imported.GET', () async {
    Uri uri = new Uri.http('localhost:8000', '/api/book');
    http.Response response = await http.get(uri);

    expect(response.body, 'Get book');
    expect(response.statusCode, 200);
  });

  test('Group.POST.StringParam', () async {
    Uri uri = new Uri.http('localhost:8000', '/api/book/some/param');
    http.Response response = await http.post(uri);

    expect(response.body, 'Some param');
    expect(response.statusCode, 200);
  });
}
