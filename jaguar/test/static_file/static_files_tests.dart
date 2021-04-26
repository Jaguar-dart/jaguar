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
    Jaguar server = Jaguar();
    setUpAll(() async {
      server = Jaguar(port: port);
      server.staticFiles('files/*', 'test/static_file/files_root/files',
          mimeTypes: [
            (f) => f.path.endsWith('.ndjson') ? 'application/x-ndjson' : null,
            (f) => f.path.endsWith('override.txt') ? 'image/png' : null,
            (f) => f.path.endsWith('.auto') &&
                    f.readAsStringSync().startsWith('<!DOCTYPE html>')
                ? 'text/html'
                : null,
          ]);
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

    test('directory/ (implicit index.html)', () async {
      await resty
          .get('http://localhost:$port/files/directory/')
          .exact(statusCode: 200, mimeType: 'text/html');
    });

    test('contents.ndjson', () async {
      await resty
          .get('http://localhost:$port/files/contents.ndjson')
          .exact(statusCode: 200, mimeType: 'application/x-ndjson');
    });

    test('directory/override.txt', () async {
      await resty
          .get('http://localhost:$port/files/directory/override.txt')
          .exact(statusCode: 200, mimeType: 'image/png');
    });

    test('html.auto', () async {
      await resty
          .get('http://localhost:$port/files/html.auto')
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
      var response = await resty.globalClient!.get(uri);
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
  String get authority => '';

  @override
  UriData? get data => null;

  @override
  String get fragment => '';

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
  Uri normalizePath() => Uri();

  @override
  String get origin => '';

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
    String? scheme,
    String? userInfo,
    String? host,
    int? port,
    String? path,
    Iterable<String>? pathSegments,
    String? query,
    Map<String, dynamic /*String|Iterable<String>*/ >? queryParameters,
    String? fragment,
  }) =>
      Uri();

  @override
  Uri resolve(String reference) => Uri();

  @override
  Uri resolveUri(Uri reference) => Uri();

  @override
  String get scheme => 'http';

  @override
  String toFilePath({bool? windows}) => '';

  @override
  String get userInfo => '';
}
