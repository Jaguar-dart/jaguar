/// File: main.dart
library jaguar.example.silly;

import 'dart:async';
import 'dart:io';
import 'package:jaguar/jaguar.dart';

part 'main.g.dart';

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  int _pingCount = 0;

  @Route('/ping', methods: const <String>['GET'])
  String ping() => "You pinged me ${++_pingCount} times, silly!";

  @Route('/pong',
      methods: const <String>['POST'],
      statusCode: 201,
      headers: const {"pong-header": "silly-pong"})
  String pong() => "Your silly pongs have no effect on me!";

  @Route('/echo/pathparam/:message',
      methods: const <String>['POST'])
  String echoPathParam(String message) => message??'No message :(';

  @Route('/echo/queryparam',
      methods: const <String>['POST'])
  String echoQueryParam(String message) => message??'No message :(';
}

Future<Null> main(List<String> args) async {
  ExampleApi tsa = new ExampleApi();

  Configuration configuration = new Configuration();
  configuration.addApi(tsa);

  await serve(configuration);
}
