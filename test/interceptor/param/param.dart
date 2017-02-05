library test.interceptor.param;

import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'param.g.dart';

class WrapWithParam implements RouteWrapper<WithParam> {
  final String who;

  final String id;

  final Map<Symbol, MakeParam> makeParams;

  const WrapWithParam({this.id, this.who, this.makeParams});

  WithParam createInterceptor() => new WithParam(this.who);
}

class WithParam extends Interceptor {
  final String who;

  WithParam(this.who);

  String pre() {
    return who;
  }
}

@Api(path: '/api')
class ExampleApi {
  @Route(path: '/user', methods: const <String>['GET'])
  @WrapWithParam(makeParams: const {#who: const MakeParamFromMethod(#who)})
  String getUser(@Input(WithParam) String who) => who;

  String who() => 'teja';
}

void main() {
  group('Interceptor.Param', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new JaguarExampleApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('ParamInjection', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'teja');
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=utf-8'});
      expect(response.statusCode, 200);
    });
  });
}
