library example.auth.user_password;

import 'dart:io';
import 'client.dart' as client;
import 'server.dart';

main() async {
  await server();

  await client.main();

  exit(0);
}
