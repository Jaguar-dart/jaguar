library test.response.stream;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

part 'stream.g.dart';

@Api(path: '/api')
class ExampleApi extends _$JaguarExampleApi {
  @Get(path: '/stream')
  Stream<List<int>> getStream(Context ctx) {
    StreamController<List<int>> streamCon = new StreamController<List<int>>();

    new Timer(new Duration(seconds: 5), () {
      streamCon.add([1, 2, 3, 4]);
      streamCon.add([5, 6, 7, 8]);
      streamCon.close();
    });

    return streamCon.stream;
  }
}

void main() {
  group('route', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 8000);
      server.addApi(new ExampleApi());
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('stream', () async {
      Uri uri = new Uri.http('localhost:8000', '/api/stream');
      http.Response response = await http.get(uri);

      expect(response.body, '\x01\x02\x03\x04\x05\x06\x07\b');
      expect(response.statusCode, 200);
    });
  });
}
