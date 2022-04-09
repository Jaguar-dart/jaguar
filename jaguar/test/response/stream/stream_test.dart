library test.jaguar.response.stream;

import 'package:http/io_client.dart' as http;
import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import '../../ports.dart' as ports;

void main() {
  resty.globalClient = http.IOClient();

  group('route', () {
    final port = ports.random;
    Jaguar server = Jaguar();
    setUpAll(() async {
      print('Using port $port');
      server = Jaguar(port: port);
      server
        ..get('/stream', (Context ctx) {
          StreamController<List<int>> streamCon = StreamController<List<int>>();

          Timer(Duration(seconds: 5), () {
            streamCon.add([1, 2, 3, 4]);
            streamCon.add([5, 6, 7, 8]);
            streamCon.close();
          });

          return streamCon.stream;
        });
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'stream',
        () => resty.get('http://localhost:$port/stream').exact(
            statusCode: 200,
            bytes: [1, 2, 3, 4, 5, 6, 7, 8],
            mimeType: 'text/plain'));
  });
}
