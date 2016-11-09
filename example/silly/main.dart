/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';

part 'main.g.dart';

@RouteGroup(path: '/myGroup')
class MyGroup extends _$JaguarMyGroup {
  @Get('/')
  String get() => "get my group";
}

@RouteGroup(path: '/mySecondGroup')
class MySecondGroup extends _$JaguarMySecondGroup {
  @Get('/')
  String get() => "get mys second group";
}

/// Example of basic API class
@RouteGroup()
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

  @Group()
  MyGroup myGroup = new MyGroup();

  @Group()
  MySecondGroup mySecondGroup = new MySecondGroup();
}

Future<Null> main(List<String> args) async {
  ExampleApi api = new ExampleApi();

  Configuration configuration = new Configuration();
  configuration.addApi(api);

  await serve(configuration);
}
