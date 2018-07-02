library example.simple;

import 'dart:io';
import 'client.dart';
import 'server.dart' as server;

main() async {
  await server.main();

  await runClient();

  exit(0);
}
