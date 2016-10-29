import 'dart:async';

import 'package:jaguar/jaguar.dart' as jaguar;

import 'forum.dart';

Future<Null> main(List<String> args) async {
  ForumApi tsa = new ForumApi();

  jaguar.Configuration configuration =
      new jaguar.Configuration();
  configuration.addApi(tsa);

  await jaguar.serve(configuration);
}
