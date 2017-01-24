library test.exception.exception;

import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'param.dart';
part 'custom.dart';
part 'exception.g.dart';

@Api(path: '/api')
@ValidationExceptionHandler()
class ExampleApi extends Object
    with _$JaguarExampleApi
    implements RequestHandler {
  @Get(path: '/user')
  @CustomExceptionHandler()
  String getUser({String who}) {
    if (who == null) {
      throw new CustomException(5, '`who` query parameter must be provided!');
    }

    return who;
  }

  @Post(path: '/user')
  @WrapUserParser()
  @Input(UserParser)
  User post(User user) => user;
}

void main() {
  group('Exception', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new ExampleApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('Exception message', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'who1': 'kleak'});
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent,
          r'{"Code": 5, "Message": "`who` query parameter must be provided! }');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 400);
    });

    test('No exception', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'who': 'kleak'});
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, r'kleak');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });

    test('Class exception', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'name': 'teja'});
      MockHttpRequest rq = new MockHttpRequest(uri, method: 'POST');
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(
          response.mockContent, r'{"Field": age, "Message": "Is required! }');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 400);
    });

    test('Multiple exceptions', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'age': '27'});
      MockHttpRequest rq = new MockHttpRequest(uri, method: 'POST');
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(
          response.mockContent, r'{"Field": name, "Message": "is required! }');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 400);
    });

    test('Exceptions in interceptor', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user', {'name': ''});
      MockHttpRequest rq = new MockHttpRequest(uri, method: 'POST');
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent,
          r'{"Field": name, "Message": "Cannot be empty! }');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 400);
    });
  });
}
