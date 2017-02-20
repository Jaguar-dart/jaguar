/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';

part 'main.g.dart';

/// Example of writing a [RouteGroup]
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

/// Example of basic [API] class
@RouteGroup(path: '/api')
class ExampleApi {
  int _pingCount = 0;

  /// Example of basic [Route]
  @Route(path: '/ping', methods: const <String>['GET'])
  String ping() => "You pinged me ${++_pingCount} times, silly!";

  /// Example of setting default status code and headers in response
  @Put(
      path: '/pong',
      statusCode: 201,
      headers: const {"pong-header": "silly-pong"})
  String pong() => "Your silly pongs have no effect on me!";

  /// Example of getting path parameter in route handler arguments
  @Post(path: '/echo/pathparam/:message')
  String echoPathParam(String message) => message ?? 'No message :(';

  /// Example of getting query parameter in route handler arguments
  @Get(path: '/echo/queryparam')
  String echoQueryParam({String message}) => message ?? 'No message :(';

  /// Example of Websocket
  @Ws('/ws')
  Future websocket(WebSocket ws) async {
    ws.listen((data) => ws.add(data));
  }

  /// Example of embedding a group in another Api/RouteGroup
  @Group()
  MyGroup myGroup = new MyGroup();

  @Group()
  MySecondGroup mySecondGroup = new MySecondGroup();
}

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarExampleApi());

  await jaguar.serve();
}
