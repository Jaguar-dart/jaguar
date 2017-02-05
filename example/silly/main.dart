/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';

part 'main.g.dart';

@RouteGroup(path: '/myGroup')
class MyGroup {
  @Get(path: '/')
  String get() => "get my group";
}

@RouteGroup(path: '/mySecondGroup')
class MySecondGroup {
  @Get(path: '/')
  String get() => "get mys second group";
}

/// Example of basic API class
@RouteGroup(path: '/api')
class ExampleApi {
  int _pingCount = 0;

  /// Example of basic route
  @Route(path: '/ping', methods: const <String>['GET'])
  String ping() => "You pinged me ${++_pingCount} times, silly!";

  /// Example of setting default status code and headers in response
  @Put(
      path: '/pong',
      statusCode: 201,
      headers: const {"pong-header": "silly-pong"})
  String pong() => "Your silly pongs have no effect on me!";

  /// Example of getting path parameter in route handler arguments
  @Route(path: '/echo/pathparam/:message', methods: const <String>['POST'])
  String echoPathParam(String message) => message ?? 'No message :(';

  /// Example of getting query parameter in route handler arguments
  @Route(path: '/echo/queryparam', methods: const <String>['POST'])
  String echoQueryParam({String message}) => message ?? 'No message :(';

  @Ws('/ws')
  Future websocket(WebSocket ws) async {
    ws.listen((data) => ws.add(data));
  }

  @Group()
  MyGroup myGroup = new MyGroup();

  @Group()
  MySecondGroup mySecondGroup = new MySecondGroup();
}

Future<Null> main(List<String> args) async {
  Configuration configuration = new Configuration();
  configuration.addApi(new JaguarExampleApi());

  await serve(configuration);
}
