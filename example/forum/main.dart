import 'dart:async';

import 'package:jaguar/jaguar.dart';

import 'forum.dart';

Future<Null> main(List<String> args) async {
  Jaguar jaguar = new Jaguar();
  jaguar.addApi(new JaguarForumApi());

  await jaguar.serve();
}
