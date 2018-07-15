library example.simple;

import 'dart:io';
import 'client.dart' as client;
import 'server.dart' as server;

main() async {
  await server.main();

  await client.main();

  exit(0);
}
