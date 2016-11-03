part of jaguar.testing.mock;

class MockHttpRequest implements HttpRequest {
  /// Uri of the request
  @override
  final Uri uri;

  final MockHttpHeaders headers;

  /// Method of the request
  @override
  final String method;

  final bool followRedirects;

  /// The Http response object for this request
  final MockHttpResponse response = new MockHttpResponse();

  MockHttpRequest(this.uri,
      {this.method: 'GET',
      this.followRedirects: true,
      DateTime ifModifiedSince,
      HttpHeaders header})
      : headers = header ?? new MockHttpHeaders() {
    if (ifModifiedSince != null) {
      headers.ifModifiedSince = ifModifiedSince;
    }
  }

  /*
   * Implemented to remove editor warnings
   */
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
