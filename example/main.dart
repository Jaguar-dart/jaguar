library main;

import 'dart:async';

import 'package:jaguar/jaguar.dart' as jaguar;

import 'api.dart';

Future<Null> main(List<String> args) async {
  ExampleApi tsa = new ExampleApi();

  jaguar.Configuration configuration =
      new jaguar.Configuration(multiThread: true);
  configuration.addApi(tsa);

  await jaguar.serve(configuration);
}
