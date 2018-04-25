part of jaguar.http.request;

/// [Request] contains information about HTTP request
class _Request implements Request {
  final HttpRequest _request;

  _Request(this._request);

  /// The client certificate of the client making the request.
  X509Certificate get certificate => _request.certificate;

  /// Information about the client connection.
  HttpConnectionInfo get connectionInfo => _request.connectionInfo;

  /// The content length of the request body.
  int get contentLength => _request.contentLength;

  /// The cookies in the request, from the Cookie headers.
  List<Cookie> get cookies => _request.cookies;

  /// The request headers.
  HttpHeaders get headers => _request.headers;

  /// The method, such as 'GET' or 'POST', for the request.
  String get method => _request.method;

  /// The persistent connection state signaled by the client.
  bool get persistentConnection => _request.persistentConnection;

  /// The HTTP protocol version used in the request, either "1.0" or "1.1".
  String get protocolVersion => _request.protocolVersion;

  /// The requested URI for the request.
  Uri get requestedUri => _request.requestedUri;

  /// The URI for the request.
  Uri get uri => _request.uri;

  /// Upgrades the request to websocket request
  Future<WebSocket> get upgradeToWebSocket =>
      WebSocketTransformer.upgrade(_request);

  /// Returns the body of HTTP request
  Future<List<int>> get body async {
    final BytesBuilder builder = await _request.fold(new BytesBuilder(),
        (BytesBuilder builder, List<int> data) => builder..add(data));

    List<int> body = builder.takeBytes();
    return body;
  }
}
