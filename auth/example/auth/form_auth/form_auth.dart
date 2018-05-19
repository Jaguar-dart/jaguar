library example.auth.user_password;

import 'dart:io';
import 'client.dart';
import 'server.dart';

main() async {
  await server();

  await runClient();

  exit(0);
}
