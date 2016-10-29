[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)

# Jaguar

Jaguar, a server framework built for **speed, simplicity and extensiblity**.

## Advantages of Jaguar

1. Keeps your route handlers concise and clean
2. Bare metal speed achieved through code generation
3. Extensible interceptor infrastructure
4. Generates API console client to try your server without writing single line of
client code
5. Mock HTTP requests and use dependency injection to test your API
6. Optional Firebase/Parse like no code or little code servers

Even though Jaguar is feature rich, it is simpler and easy to get started.

## Example

### Simple routes

```dart
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
```

## The State of Jaguar

Jaguar is currently under development. Feedbacks and contributions are welcome.

## Issue

If you have an issue please tell us which version of jaguar and if you can provide
an example this will simplify the path to resolve it :).
