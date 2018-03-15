library test.exception.exception;

import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

part 'param.dart';
part 'custom.dart';
part 'exception.g.dart';

@Api(path: '/api')
@ValidationExceptionHandler()
class ExampleApi extends _$JaguarExampleApi {
  @Get(path: '/user')
  @CustomExceptionHandler()
  String getUser(Context ctx) {
    String who = ctx.query['who'];
    if (who == null) {
      throw new CustomException(5, '`who` query parameter must be provided!');
    }

    return who;
  }

  @Post(path: '/user')
  @Wrap(const [userParser])
  User post(Context ctx) => ctx.getInterceptorResult(UserParser);

  static UserParser userParser(Context ctx) => new UserParser();
}

void main() {
  group('Exception', () {
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

  group('Exception reflected', () {
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
      'Exception message',
      () => resty
          .get('/api/user')
          .authority('http://localhost:8000')
          .query('who1', 'kleak')
          .exact(
              statusCode: 400,
              body:
                  r'{"Code": 5, "Message": "`who` query parameter must be provided! }'));

  test(
      'No exception',
      () => resty
          .get('/api/user')
          .authority('http://localhost:8000')
          .query('who', 'kleak')
          .exact(statusCode: 200, body: r'kleak'));

  test(
      'Class exception',
      () => resty
          .get('/api/user')
          .authority('http://localhost:8000')
          .query('name', 'teja')
          .exact(
              statusCode: 400,
              body:
                  r'{"Code": 5, "Message": "`who` query parameter must be provided! }'));

  test(
      'Multiple exceptions',
      () => resty
          .post('/api/user')
          .authority('http://localhost:8000')
          .query('age', '27')
          .exact(
              statusCode: 400,
              body: r'{"Field": name, "Message": "is required! }'));

  test(
      'Exceptions in interceptor',
      () => resty
          .post('/api/user')
          .authority('http://localhost:8000')
          .query('name', '')
          .exact(
              statusCode: 400,
              body: r'{"Field": name, "Message": "Cannot be empty! }'));
}
