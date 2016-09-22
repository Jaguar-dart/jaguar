library main;

import 'dart:async';

import 'package:jaguar/jaguar.dart' as jaguar;

import 'api.dart';

Future<Null> main(List<String> args) async {
  TestApi tsa = new TestApi();

  jaguar.Configuration jaguarConfiguraion =
      new jaguar.Configuration(multiThread: true);
  jaguarConfiguraion.addApi(tsa);

  await jaguar.serve(jaguarConfiguraion);
}
