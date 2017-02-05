import 'dart:async';

import 'package:jaguar/jaguar.dart' as jaguar;

import 'forum.dart';

Future<Null> main(List<String> args) async {
  jaguar.Configuration configuration = new jaguar.Configuration();
  configuration.addApi(new JaguarForumApi());

  await jaguar.serve(configuration);
}
