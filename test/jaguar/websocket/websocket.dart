library test.jaguar.websocket;

import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'websocket.g.dart';

@Api(path: '/api')
class ExampleApi {
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
