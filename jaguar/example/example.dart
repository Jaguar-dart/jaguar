library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';

Future<Null> main(List<String> args) async {
  final server = new Jaguar();
  server.getJson(
      '/moto',
      (Context ctx) => {
            'server': 'Jaguar',
            'motto': 'Speed. Simplicity. Flexiblity. Extensiblity.'
          });

  await server.serve();
}
