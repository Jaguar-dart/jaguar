library test.jaguar.group;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

import 'book.dart';

part 'main.g.dart';

@RouteGroup()
class UserApi {
  @Route(methods: const <String>['GET'])
  String getUser() => 'Get user';

  @Route(path: '/statuscode', methods: const <String>['GET'], statusCode: 201)
  String statusCode() => 'status code';
}

@Api(path: '/api')
class ExampleApi {
  @Group(path: '/user')
  UserApi user = new UserApi();

  @Group(path: '/book')
  BookApi book = new BookApi();

  @Route(path: '/version', methods: const <String>['GET'])
  String statusCode() => '1.0';
}

void main() {
  group('Group', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Route', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/version');
      http.Response response = await http.get(uri);

      expect(response.body, '1.0');
      expect(response.statusCode, 200);
    });

    test('Group.GET', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user');
      http.Response response = await http.get(uri);

      expect(response.body, 'Get user');
      expect(response.statusCode, 200);
    });

    test('Group.DefaultStatusCode', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user/statuscode');
      http.Response response = await http.get(uri);

      expect(response.body, 'status code');
      expect(response.statusCode, 201);
    });

    test('Group.Imported.GET', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/book');
      http.Response response = await http.get(uri);

      expect(response.body, 'Get book');
      expect(response.statusCode, 200);
    });

    test('Group.POST.StringParam', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/book/some/param');
      http.Response response = await http.post(uri);

      expect(response.body, 'Some param');
      expect(response.statusCode, 200);
    });
  });
}
