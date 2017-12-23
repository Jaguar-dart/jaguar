library test.jaguar.websocket;

import 'dart:io';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

String incrementerSocket(dynamic data, [WebSocket ws]) {
  final int ret = int.parse(data) + 1;
  return ret.toString();
}

void main() {
  group('route', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.get('/ws', socketHandler(incrementerSocket));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('GET', () async {
      final WebSocket socket =
          await WebSocket.connect('ws://localhost:8000/ws');

      socket.add('5');

      expect(await socket.first, '6');
    });
  });
}
