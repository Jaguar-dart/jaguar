library test.interceptor.param;

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

class WrapWithParam implements RouteWrapper<WithParam> {
  final CheckerImpl checker;

  final String id;

  final Map<Symbol, MakeParam> makeParams;

  const WrapWithParam({this.id, this.checker, this.makeParams});

  WithParam createInterceptor() => new WithParam(this.checker);
}

class WithParam extends Interceptor {
  final CheckerImpl checker;

  WithParam(this.checker);

  String pre() {
    return checker.who;
  }
}

@Api(path: '/api')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Route(path: '/user', methods: const <String>['GET'])
  @WrapWithParam(
      makeParams: const {#checker: const MakeParamFromType(CheckerImpl)})
  String getUser(@Input(WithParam) String who) => who;
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
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=us-ascii'});
      expect(response.statusCode, 200);
    });
  });
}
