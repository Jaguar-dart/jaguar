library test.exception.exception;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'param.dart';
part 'custom.dart';
part 'exception.g.dart';

@Api(path: '/api')
@ValidationExceptionHandler()
class ExampleApi {
  @Get(path: '/user')
  @CustomExceptionHandler()
  String getUser(Context ctx) {
    String who = ctx.queryParams['who'];
    if (who == null) {
      throw new CustomException(5, '`who` query parameter must be provided!');
    }

    return who;
  }

  UserParser userParser(Context ctx) => new UserParser();

  @Post(path: '/user')
  @Wrap(const [#userParser])
  User post(Context ctx) => ctx.getInput(UserParser);
}

void main() {
  group('Exception', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar();
      server.addApi(new JaguarExampleApi(new ExampleApi()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('Exception message', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'who1': 'kleak'});
      http.Response response = await http.get(uri);

      expect(response.body,
          r'{"Code": 5, "Message": "`who` query parameter must be provided! }');
      expect(response.statusCode, 400);
    });

    test('No exception', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'who': 'kleak'});
      http.Response response = await http.get(uri);

      expect(response.body, r'kleak');
      expect(response.statusCode, 200);
    });

    test('Class exception', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'name': 'teja'});
      http.Response response = await http.get(uri);

      expect(response.body,
          r'{"Code": 5, "Message": "`who` query parameter must be provided! }');
      expect(response.statusCode, 400);
    });

    test('Multiple exceptions', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'age': '27'});
      http.Response response = await http.post(uri);

      expect(response.body, r'{"Field": name, "Message": "is required! }');
      expect(response.statusCode, 400);
    });

    test('Exceptions in interceptor', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'name': ''});
      http.Response response = await http.post(uri);

      expect(response.body, r'{"Field": name, "Message": "Cannot be empty! }');
      expect(response.statusCode, 400);
    });
  });
}
