/// [Request] encapsulates a HTTP requests. It provides various convenience methods
/// to help writing route handlers easier.
///
/// **Decoding JSON requests**
/// [bodyAsJson], [bodyAsJsonList] and [bodyAsJsonMap] methods decode JSON requests
/// with a single line of code.
///
/// [bodyAsUrlEncodedForm] method decodes url-encoded form requests with a single
/// line of code.
///
/// [bodyAsFormData] decode multipart/form-data requests.
library jaguar.http.request;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

part 'form_field.dart';
part 'request_impl.dart';

/// [Request] contains information about HTTP request
abstract class Request {
  factory Request(HttpRequest request) => _Request(request);

  /// The URI for the request
  ///
  /// This provides access to the path and query string for the request.
  Uri get uri;

  /// The requested URI for the request
  ///
  /// The returned URI is reconstructed by using http-header fields, to access
  /// otherwise lost information, e.g. host and scheme.
  ///
  /// To reconstruct the scheme, first 'X-Forwarded-Proto' is checked, and then
  /// falling back to server type.
  ///
  /// To reconstruct the host, first 'X-Forwarded-Host' is checked, then 'Host'
  /// and finally calling back to server.
  Uri get requestedUri;

  /// The method, such as 'GET' or 'POST', for the request.
  String get method;

  /// The request headers.
  HttpHeaders get headers;

  /// The cookies in the request, from the Cookie headers.
  List<Cookie> get cookies;

  /// Connection information of the request
  HttpConnectionInfo get connectionInfo;

  /// The client certificate of the client making the request
  ///
  /// This value is null if the connection is not a secure TLS or SSL connection,
  /// or if the server does not request a client certificate, or if the client
  /// does not provide one.
  X509Certificate get certificate;

  /// The content length of the request body
  ///
  /// If the size of the request body is not known in advance,
  /// this value is -1.
  int get contentLength;

  /// The persistent connection state signaled by the client
  bool get persistentConnection;

  /// The HTTP protocol version used in the request, either "1.0" or "1.1".
  String get protocolVersion;

  /// Upgrades the request to a websocket request and returns the websocket
  Future<WebSocket> get upgradeToWebSocket;

  /// Returns raw body of HTTP request
  Future<List<int>> get body;

  HttpRequest get ioRequest;
}
