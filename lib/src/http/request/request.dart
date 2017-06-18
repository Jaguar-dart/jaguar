library jaguar.src.http.request;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:mime/mime.dart';
import 'package:http_server/http_server.dart';

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
class Request {
  final HttpRequest _request;

  Request(this._request);

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

  /// The session for the given request.
  HttpSession get session => _request.session;

  /// The URI for the request.
  Uri get uri => _request.uri;

  /// Private cache for request body
  List<int> _body;

  /// Returns the body of HTTP request
  Future<List<int>> get body async {
    if (_body is List<int>) return _body;

    final BytesBuilder builder = await _request.fold(new BytesBuilder(),
        (BytesBuilder builder, List<int> data) => builder..add(data));

    _body = builder.takeBytes();
    return _body;
  }

  /// Returns the body of HTTP request
  Future<Stream<List<int>>> get bodyAsStream async {
    final List<int> bodyRaw = await body;
    return new Stream<List<int>>.fromIterable(<List<int>>[bodyRaw]);
  }

  /// Returns body as text
  Future<String> bodyAsText(Encoding encoding) async {
    return encoding.decode(await body);
  }

  /// Upgrades the request to websocket request
  Future<WebSocket> get upgradeToWebSocket =>
      WebSocketTransformer.upgrade(_request);

  /// Decodes JSON body of the request
  Future<dynamic> bodyAsJson({Encoding encoding: UTF8}) async {
    final String text = await bodyAsText(encoding);
    return JSON.decode(text);
  }

  /// Decodes JSON body of the request as [Map]
  Future<Map> bodyAsJsonMap({Encoding encoding: UTF8}) async {
    final String text = await bodyAsText(encoding);
    final ret = JSON.decode(text);

    if (ret == null) return null;

    if (ret is! Map) throw new Exception("Json body is not a Map!");

    return ret;
  }

  /// Decodes JSON body of the request as [List]
  Future<List> bodyAsJsonList({Encoding encoding: UTF8}) async {
    final String text = await bodyAsText(encoding);
    final ret = JSON.decode(text);

    if (ret == null) return null;

    if (ret is! List) throw new Exception("Json body is not a List!");

    return ret;
  }

  /// Decodes url-encoded form from the body and returns Map<String, String>
  Future<Map<String, String>> bodyAsUrlEncodedForm(
      {Encoding encoding: UTF8}) async {
    final String text = await bodyAsText(encoding);
    return text
        .split("&")
        .map((String part) => part.split("="))
        .map((List<String> part) => <String, String>{part.first: part.last})
        .reduce((Map<String, String> value, Map<String, String> element) =>
            value..putIfAbsent(element.keys.first, () => element.values.first));
  }

  /// Decodes `multipart/form-data` body
  Future<Map<String, FormField>> bodyAsFormData(
      {Encoding encoding: UTF8}) async {
    if (!headers.contentType.parameters.containsKey('boundary')) {
      return null;
    }

    final String boundary = headers.contentType.parameters['boundary'];

    final Map<String, FormField> ret = {};

    final Stream<List<int>> bodyStream = await bodyAsStream;

    // Transform body to [MimeMultipart]
    final transformer = new MimeMultipartTransformer(boundary);
    final Stream<MimeMultipart> stream = bodyStream.transform(transformer);

    await for (MimeMultipart part in stream) {
      HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      // Parse field content type
      final ContentType contentType = multipart.contentType;

      final String name = multipart.contentDisposition.parameters['name'];

      final String fn = multipart.contentDisposition.parameters['filename'];

      // Create field
      if (fn is! String && multipart.isText) {
        final String data = await multipart.join();
        final field = new StringFormField(name, data, contentType: contentType);
        ret[field.name] = field;
      } else if (multipart.isText) {
        final field = new TextFileFormField(name, multipart as Stream<String>,
            contentType: contentType, filename: fn);
        ret[field.name] = field;
      } else {
        final field = new BinaryFileFormField(
            name, multipart as Stream<List<int>>,
            contentType: contentType, filename: fn);
        ret[field.name] = field;
      }
    }

    return ret;
  }
}

/// Abstract class for fields on `multipart/form-data`
abstract class FormField<T> {
  /// Name of the field
  String get name;

  /// Value of the field
  T get value;

  /// content-type of the field
  ContentType get contentType;

  /// Hash code
  int get hashCode => name.hashCode;
}

/// String field in the `multipart/form-data`
///
/// Contains `String` value
class StringFormField implements FormField {
  /// Name of the field
  final String name;

  /// Value of the field
  final String value;

  /// content-type of the field
  final ContentType contentType;

  StringFormField(this.name, this.value, {this.contentType});

  bool operator ==(other) {
    if (other is! StringFormField) {
      return false;
    }

    return _equality(other as StringFormField);
  }

  bool _equality(StringFormField other) {
    return name == other.name &&
        value == other.value &&
        contentType.mimeType == other.contentType.mimeType &&
        contentType.charset == other.contentType.charset;
  }

  int get hashCode => name.hashCode;

  String toString() {
    return "StringFormField('$name', '$value', '$contentType')";
  }
}

class TextFileFormField implements FormField {
  /// Name of the field
  final String name;

  /// Value of the field
  ///
  /// Returns a stream of text
  final Stream<String> value;

  /// content-type of the field
  final ContentType contentType;

  /// File of the file field
  final String filename;

  TextFileFormField(this.name, this.value, {this.contentType, this.filename});

  bool operator ==(other) {
    return name == other.name &&
        contentType.mimeType == other.contentType.mimeType &&
        contentType.charset == other.contentType.charset &&
        filename == other.filename;
  }

  int get hashCode => name.hashCode;

  String toString() {
    return "FileFormField('$name', '$contentType', '$filename')";
  }
}

class BinaryFileFormField implements FormField {
  /// Name of the field
  final String name;

  /// Value of the field
  final Stream<List<int>> value;

  /// content-type of the field
  final ContentType contentType;

  /// File of the file field
  final String filename;

  BinaryFileFormField(this.name, this.value, {this.contentType, this.filename});

  bool operator ==(other) {
    return name == other.name &&
        contentType.mimeType == other.contentType.mimeType &&
        contentType.charset == other.contentType.charset &&
        filename == other.filename;
  }

  int get hashCode => name.hashCode;

  String toString() {
    return "FileFormField('$name', '$contentType', '$filename')";
  }
}
