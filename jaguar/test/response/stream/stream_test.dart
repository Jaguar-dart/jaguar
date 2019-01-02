library test.response.stream;

import 'package:http/io_client.dart' as http;
import 'dart:async';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = new http.IOClient();

  group('route', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server
        ..get('/stream', (Context ctx) {
          StreamController<List<int>> streamCon =
              new StreamController<List<int>>();

          new Timer(new Duration(seconds: 5), () {
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
        () => resty.get('http://localhost:10000/stream').exact(
            statusCode: 200,
            bytes: [1, 2, 3, 4, 5, 6, 7, 8],
            mimeType: 'text/plain'));
  });
}
