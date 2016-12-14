part of jaguar.testing.mock;

class MockHttpResponse implements HttpResponse {
  /// Http headers in response
  final MockHttpHeaders headers = new MockHttpHeaders();

  /// Buffer to store response body
  final List<int> _buffer = new List<int>();

  String _reasonPhrase;

  final List<Cookie> cookies = [];

  MockHttpResponse();

  int statusCode = HttpStatus.OK;

  String get reasonPhrase => _findReasonPhrase(statusCode);

  void set reasonPhrase(String value) {
    _reasonPhrase = value;
  }

  Future close() async {}

  void add(List<int> data) {
    _buffer.addAll(data);
  }

  Future<Null> addStream(Stream<List<int>> stream) async {
    await for (List<int> data in stream) {
      add(data);
    }
  }

  void addError(error, [StackTrace stackTrace]) {
    // doesn't seem to be hit...hmm...
  }

  Future redirect(Uri location, {int status: HttpStatus.MOVED_TEMPORARILY}) {
    this.statusCode = status;
    headers.set(HttpHeaders.LOCATION, location.toString());
    return close();
  }

  void write(Object obj) {
    var str = obj.toString();
    add(UTF8.encode(str));
    print(str);
  }

  // Implemented to remove editor warnings
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  String get mockContent => UTF8.decode(_buffer);

  List<int> get mockContentBinary => _buffer;

  // Copied from SDK http_impl.dart @ 845 on 2014-01-05
  // TODO: file an SDK bug to expose this on HttpStatus in some way
  String _findReasonPhrase(int statusCode) {
    if (_reasonPhrase != null) {
      return _reasonPhrase;
    }

    switch (statusCode) {
      case HttpStatus.NOT_FOUND:
        return "Not Found";
      default:
        return "Status $statusCode";
    }
  }
}
