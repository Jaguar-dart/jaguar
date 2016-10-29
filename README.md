[![Build Status](https://travis-ci.org/Jaguar-dart/jaguar.svg?branch=master)](https://travis-ci.org/Jaguar-dart/jaguar)

# Jaguar

Jaguar, a server framework built for **speed, simplicity and extensiblity**.

Advantages of Jaguar

1. Keeps your route handlers concise and clean
2. Extensible interceptor infrastructure
3. Bare metal speed achieved through code generation
4. Generated API console client to try your server without writing single line of
client
5. Mock HTTP requests and use dependency injection to test your API
6. Optional Firebase/Parse like no code or little code servers

Even though Jaguar is feature rich, it is simpler and easy to get started.

## Example

### Simple routes

```dart
/// File: main.dart

import 'dart:async';

import 'package:jaguar/jaguar.dart' as jaguar;

part 'main.g.dart';

@Api()
class ExampleApi extends _$JaguarExampleApi {
  @Route(path: 'ping', methods: const <String>['GET'])
  String get ping => "got ping";

  @Route(path: 'ping', methods: const <String>['POST'], statusCode: 201, headers: {})
  String get ping => "posted pong!";
}

Future<Null> main(List<String> args) async {
  ExampleApi tsa = new ExampleApi();

  jaguar.Configuration configuration =
      new jaguar.Configuration();
  configuration.addApi(tsa);

  await jaguar.serve(configuration);
}
```

## The State of Jaguar

Jaguar is currently under development. Feedbacks and contributions are welcome.

## Issue

If you have an issue please tell us which version of jaguar and if you can provide
an example this will simplify the path to resolve it :).
