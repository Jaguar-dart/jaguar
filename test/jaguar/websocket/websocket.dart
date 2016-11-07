library test.jaguar.websocket;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
//TODO import 'package:jaguar/testing.dart';

part 'websocket.g.dart';

@Api(path: '/api')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Ws('/ws')
  Future websocket(WebSocket ws) async {
    ws.listen((data) => ws.add("Hello World !"));
  }
}

void main() {
  group('route', () {
    /* TODO
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new ExampleApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});
    */
  });
}
