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
import 'dart:async';
import 'dart:convert';

import 'package:mime/mime.dart';
import 'package:http_server/http_server.dart';
import 'package:logging/logging.dart';

import 'package:jaguar/src/http/session/session.dart';

part 'form_field.dart';
part 'request_impl.dart';

/// Splits given path to composing segments
List<String> splitPathToSegments(final String paths) {
  final List<String> segments = paths.split(new RegExp('/+'));
  final res = <String>[];
  for (String part in segments) {
    if (part.length == 0) continue;
    res.add(part);
  }
  return res;
}

/// [Request] contains information about HTTP request
abstract class Request {
  factory Request(HttpRequest request, Logger log) =>
      new _Request(request, log);

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

  /// Logger to log data during request
  Logger get log;

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

  /// Returns the body of HTTP request as Stream
  Future<Stream<List<int>>> get bodyAsStream;

  /// Returns body as text
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final String body = await ctx.req.bodyAsText();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<String> bodyAsText([Encoding encoding = UTF8]);

  /// Decodes JSON body of the request
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final json = await ctx.req.bodyAsJson();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<dynamic> bodyAsJson({Encoding encoding: UTF8});

  /// Decodes JSON body of the request as [Map]
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final Map<String, dynamic> json = await ctx.req.bodyAsJsonMap();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<Map> bodyAsJsonMap({Encoding encoding: UTF8});

  /// Decodes JSON body of the request as [List]
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final List json = await ctx.req.bodyAsJsonList();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<List> bodyAsJsonList({Encoding encoding: UTF8});

  /// Decodes url-encoded form from the body and returns the form as
  /// Map<String, String>.
  ///
  /// Example:
  ///     final server = new Jaguar();
  ///     server.post('/add', (ctx) async {
  ///       final Map<String, String> map = await ctx.req.bodyAsUrlEncodedForm();
  ///       // ...
  ///     });
  ///     await server.serve();
  Future<Map<String, String>> bodyAsUrlEncodedForm({Encoding encoding: UTF8});

  /// Decodes `multipart/form-data` body
  ///
  /// Example:
  ///     server.post('/upload', (ctx) async {
  ///       final Map<String, FormField> formData = await ctx.req.bodyAsFormData();
  ///       BinaryFileFormField pic = formData['pic'];
  ///       File file = new File('bin/data/' + pic.filename);
  ///       IOSink sink = file.openWrite();
  ///       await sink.addStream(pic.value);
  ///       await sink.close();
  ///       return Response.redirect(Uri.parse("/"));
  ///     });
  Future<Map<String, FormField>> bodyAsFormData({Encoding encoding: UTF8});
}
