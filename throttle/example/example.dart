// Copyright (c) 2017, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_throttle/jaguar_throttle.dart';
import 'package:jaguar_client/jaguar_client.dart';

final client = new JsonClient(new http.IOClient());

runServer() async {
  final jaguar = new Jaguar()
    ..get('/one', (_) => 'one', before: [new Throttler.perMin(10)])
    ..get('/two', (_) => 'two', before: [new Throttler.perMin(10)]);
  await jaguar.serve();
}

runClient() async {
  for (int i = 0; i < 10; i++) {
    await client
        .get('http://localhost:8080/one')
        .expect([statusCodeIs(200), bodyIs('one')]);
  }
  await client
      .get('http://localhost:8080/one')
      .expect([statusCodeIs(429), bodyIs('Limit exceeded')]);
  await client
      .get('http://localhost:8080/two')
      .expect([statusCodeIs(429), bodyIs('Limit exceeded')]);
}

main() async {
  await runServer();
  await runClient();

  exit(0);
}
