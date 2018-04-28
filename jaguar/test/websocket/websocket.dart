library test.jaguar.websocket;

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

int incrementerSocket(dynamic data) => int.parse(data) + 1;

void main() {
  group('route', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server.ws('/ws', incrementerSocket);
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('GET', () async {
      final WebSocket socket =
          await WebSocket.connect('ws://localhost:10000/ws');
      socket.add('5');
      expect(await socket.first, '6');
    });
  });
}
