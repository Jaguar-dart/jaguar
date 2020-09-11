library test.jaguar.static_file;

import 'dart:io';
import 'package:http/io_client.dart' as http;
import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  resty.globalClient = http.IOClient();

  group('static files', () {
    final port = 10000;
    Jaguar server;
    setUpAll(() async {
      server = Jaguar(port: port);
      server.staticFiles('files/*', 'test/static_file/files_root/files');
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test('hello.txt', () async {
      await resty
          .get('http://localhost:$port/files/hello.txt')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'hello');
    });

    test('directory/hello.html', () async {
      await resty
          .get('http://localhost:$port/files/directory/hello.html')
          .exact(statusCode: 200, mimeType: 'text/html');
    });

    test('madeup.file_extension', () async {
      await resty
          .get('http://localhost:$port/files/madeup.file_extension')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'plain text');
    });

    test('missing', () async {
      await resty
          .get('http://localhost:$port/files/directory/missing.html')
          .exact(statusCode: 404, mimeType: 'text/html');
    });

    test('path traversal', () async {
      Uri uri = _StupidUri(port, ['files', '..', 'inaccessible.txt']);
      var response = await resty.globalClient.get(uri);
      expect(response.statusCode, 404);
    });
  });
}

// Does not handle '/../' before sending.
class _StupidUri implements Uri {
  final port;
  final List<String> pathSegments;

  _StupidUri(this.port, this.pathSegments);

  @override
  String get authority => null;

  @override
  UriData get data => null;

  @override
  String get fragment => null;

  @override
  bool get hasAbsolutePath => true;

  @override
  bool get hasAuthority => false;

  @override
  bool get hasEmptyPath => false;

  @override
  bool get hasFragment => false;

  @override
  bool get hasPort => true;

  @override
  bool get hasQuery => false;

  @override
  bool get hasScheme => true;

  @override
  String get host => 'localhost';

  @override
  bool get isAbsolute => true;

  @override
  bool isScheme(String scheme) => scheme == this.scheme;

  @override
  Uri normalizePath() => null;

  @override
  String get origin => null;

  @override
  String get path => '/' + pathSegments.join('/');

  @override
  String get query => '';

  @override
  Map<String, String> get queryParameters => {};

  @override
  Map<String, List<String>> get queryParametersAll => {};

  @override
  Uri removeFragment() => this;

  @override
  Uri replace({
    String scheme,
    String userInfo,
    String host,
    int port,
    String path,
    Iterable<String> pathSegments,
    String query,
    Map<String, dynamic> queryParameters,
    String fragment,
  }) =>
      null;

  @override
  Uri resolve(String reference) => null;

  @override
  Uri resolveUri(Uri reference) => null;

  @override
  String get scheme => 'http';

  @override
  String toFilePath({bool windows}) => null;

  @override
  String get userInfo => null;
}
