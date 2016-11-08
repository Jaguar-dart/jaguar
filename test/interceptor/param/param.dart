library test.interceptor.param;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'param.g.dart';

abstract class Checker {
  String get who;
}

class CheckerImpl implements Checker {
  String get who => 'CheckerImpl';

  CheckerImpl();
}

@InterceptorClass()
class WithParam extends Interceptor {
  final CheckerImpl checker;

  const WithParam({this.checker, Map<Symbol, Type> params})
      : super(params: params);

  String pre() {
    return checker.who;
  }
}

@Api(path: '/api')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route('/user', methods: const <String>['GET'])
  @WithParam(params: const {#checker: CheckerImpl})
  @Input(WithParam)
  String getUser(String who) => who;
}

void main() {
  group('Interceptor.Param', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new ExampleApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('ParamInjection', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'CheckerImpl');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });
  });
}
