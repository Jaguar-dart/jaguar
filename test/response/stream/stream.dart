library test.response.stream;

import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'stream.g.dart';

@Api(path: '/api')
class ExampleApi extends Object with _$JaguarExampleApi {
  @Get(path: '/stream')
  Stream<List<int>> getStream() {
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
    JaguarMock mock;
    setUp(() {
      Configuration config = new Configuration();
      config.addApi(new ExampleApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('stream', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/stream');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContentBinary, equals([1, 2, 3, 4, 5, 6, 7, 8]));
      expect(response.headers.toMap,
          {'content-type': 'text/plain; charset=us-ascii'});
      expect(response.statusCode, 200);
    });
  });
}
