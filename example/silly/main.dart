/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';

part 'main.g.dart';

/// Example of basic API class
@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  int _pingCount = 0;

  /// Example of basic route
  @Route('/ping', methods: const <String>['GET'])
  String ping() => "You pinged me ${++_pingCount} times, silly!";

  /// Example of setting default status code and headers in response
  @Put('/pong', statusCode: 201, headers: const {"pong-header": "silly-pong"})
  String pong() => "Your silly pongs have no effect on me!";

  /// Example of getting path parameter in route handler arguments
  @Route('/echo/pathparam/:message', methods: const <String>['POST'])
  String echoPathParam(String message) => message ?? 'No message :(';

  /// Example of getting query parameter in route handler arguments
  @Route('/echo/queryparam', methods: const <String>['POST'])
  String echoQueryParam({String message}) => message ?? 'No message :(';

  @Ws('/ws')
  Future websocket(WebSocket ws) async {
    ws.listen((data) => ws.add(data));
  }
}

Future<Null> main(List<String> args) async {
  ExampleApi api = new ExampleApi();

  Configuration configuration = new Configuration();
  configuration.addApi(api);

  await serve(configuration);
}
