library test.interceptor.state;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'state.g.dart';

class State {
  String message = "";

  State();
}

class WithState extends Interceptor {
  final State state;

  const WithState({this.state});

  void pre() {
    state.message = 'hello';
  }

  @Input(RouteResponse)
  Response post(Response response) {
    response.value = state.message;
    return response;
  }

  static State createState() => new State();
}

@Api(path: '/api')
class StateApi extends Object with _$JaguarStateApi {
  @Route(path: '/user', methods: const <String>['GET'])
  @WithState()
  void getUser() {}
}

void main() {
  group('Interceptor.State', () {
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new StateApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('StateInjection', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/user');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'hello');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });
  });
}
