library jaguar.src.http.response;

import 'dart:async';
import 'dart:convert' as cnv;
import 'dart:io';

import 'package:jaguar/src/annotations/import.dart';
import 'package:path/path.dart' as p;

part 'headers.dart';

class StrResponse extends Response<String> {
  StrResponse(String value,
      {int statusCode: 200,
        Map<String, dynamic> headers: const {},
        String mimeType,
        String charset})
      : super(
    value,
    statusCode: statusCode,
    headers: headers,
    mimeType: mimeType,
    charset: charset,
  );

  /// Encodes the given value to JSON and returns a `Response`
  StrResponse.json(dynamic value,
      {statusCode: 200,
        Map<String, dynamic> headers: const {},
        String mimeType: 'application/json',
        String charset})
      : this(
    cnv.json.encode(value),
    statusCode: statusCode,
    headers: headers,
    mimeType: mimeType,
    charset: charset,
  );
}

class ByteResponse extends Response<List<int>> {
  ByteResponse(List<int> value,
      {statusCode: 200,
        Map<String, dynamic> headers: const {},
        String mimeType,
        String charset})
      : super(value,
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType,
      charset: charset);

  @override
  Future writeValue(HttpResponse resp) async {
    await resp.add(value);
  }
}

class StreamResponse extends Response<Stream<List<int>>> {
  StreamResponse(Stream<List<int>> value,
      {statusCode: 200,
        Map<String, dynamic> headers: const {},
        String mimeType,
        String charset})
      : super(value,
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType,
      charset: charset);

  StreamResponse.fromFile(File file,
      {statusCode: 200,
        Map<String, dynamic> headers: const {},
        String mimeType,
        String charset})
      : this(
    file.openRead(),
    statusCode: statusCode,
    headers: headers,
    mimeType: mimeType = MimeType.ofFile(file),
    charset: charset,
  );

  static Future<StreamResponse> fromPath(String path,
      {int statusCode: 200,
        Map<String, dynamic> headers: const {},
        String mimeType,
        String charset}) async {
    final file = new File(path);
    if (!await file.exists()) {
      // TODO
      throw new Exception();
    }
    return new StreamResponse.fromFile(file,
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType,
        charset: charset);
  }

  @override
  Future writeValue(HttpResponse resp) async {
    await resp.addStream(value);
  }
}

class Redirect extends Response<Uri> {
  Redirect(Uri value,
      {statusCode: HttpStatus.MOVED_PERMANENTLY,
        Map<String, dynamic> headers: const {},
        String mimeType,
        String charset})
      : super(value,
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType,
      charset: charset);

  Redirect.found(value,
      {Map<String, dynamic> headers: const {},
        statusCode = HttpStatus.MOVED_TEMPORARILY})
      : this(
    value,
    headers: headers,
    statusCode: statusCode,
  );

  Redirect.seeOther(value,
      {Map<String, dynamic> headers: const {},
        statusCode = HttpStatus.SEE_OTHER})
      : this(
    value,
    headers: headers,
    statusCode: statusCode,
  );

  Redirect.temporaryRedirect(value,
      {Map<String, dynamic> headers: const {},
        statusCode = HttpStatus.TEMPORARY_REDIRECT})
      : this(
    value,
    headers: headers,
    statusCode: statusCode,
  );

  Redirect.permanentRedirect(value,
      {Map<String, dynamic> headers: const {}, statusCode = 308})
      : this(
    value,
    headers: headers,
    statusCode: statusCode,
  );

  @override
  Future writeValue(HttpResponse resp) async {
    await resp.redirect(value, status: statusCode);
  }
}

/// HTTP response type for Jaguar
///
/// [ValueType] specializes the value contained by it.
///
/// [writeResponse] can be used to write response to underlying abstracted
/// response object. Different [ValueTypes] are differently when they are written
/// to the response. For more info refer the docs on [writeResponse] method.
class Response<ValueType> {
  /// Value or body of the HTTP response
  ValueType value;

  /// Status code of the HTTP response
  int statusCode;

  /// HTTP headers
  final JaguarHttpHeaders headers = new JaguarHttpHeaders();

  /// HTTP cookies
  final List<Cookie> cookies = [];

  Response(this.value,
      {this.statusCode,
        Map<String, dynamic> headers: const {},
        String mimeType,
        String charset}) {
    for (final String name in headers.keys) {
      this.headers.add(name, headers[name]);
    }

    if (mimeType != null) this.headers.mimeType = mimeType;
    if (charset != null) this.headers.charset = charset;
  }

  Response.fromRoute(dynamic value, HttpMethod route) {
    statusCode = route.statusCode;

    this.value = route.responseProcessor != null
        ? route.responseProcessor(value)
        : value;

    if (route.headers != null) {
      for (final String name in route.headers.keys) {
        final value = route.headers[name];
        this.headers.add(name, value);
      }
    }
    headers.mimeType = route.mimeType;
    headers.charset = route.charset;
  }

  /// Returns a `Response` object that performs a redirect
  static Response<Uri> redirect(Uri uri,
      {int statusCode: HttpStatus.MOVED_PERMANENTLY}) =>
      new Redirect(uri);

  // TODO XML

  /// Writes body of the HTTP response from [value] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  Future writeResponse(HttpResponse resp) async {
    resp.statusCode = statusCode;

    for (dynamic name in headers.headers.keys) {
      resp.headers.set(name, headers.headers[name]);
    }

    resp.cookies.addAll(cookies);
    await writeValue(resp);
  }

  Future writeValue(HttpResponse resp) async {
    resp.write(value);
  }
}

/// A namespace class to expose mime type specific features
abstract class MimeType {
  /// Mime type for HTML
  static const String html = "text/html";

  /// Mime type for Javascript
  static const String javascript = "application/javascript";

  /// Mime type for CSS
  static const String css = "text/css";

  /// Mime type for Dart
  static const String dart = "application/dart";

  /// Mime type for PNG
  static const String png = "image/png";

  /// Mime type for JPEG
  static const String jpeg = "image/jpeg";

  /// Mime type for GIF
  static const String gif = "image/gif";

  /// Mime type for JSON
  static const String json = "application/json";

  /// Mime type for SVG
  static const String svg = "image/svg+xml";

  /// Map of file extension to mime type
  static const fromFileExtension = const <String, String>{
    "html": html,
    "js": javascript,
    "css": css,
    "dart": dart,
    "png": png,
    "jpg": jpeg,
    "jpeg": jpeg,
    "gif": gif,
    "svg": svg,
  };

  /// Returns mime type of [file] based on its extension
  static String ofFile(File file) {
    String fileExtension = p.extension(file.path);

    if (fileExtension.startsWith('.'))
      fileExtension = fileExtension.substring(1);

    if (fileExtension.length == 0) return null;

    if (fromFileExtension.containsKey(fileExtension)) {
      return fromFileExtension[fileExtension];
    }

    return null;
  }
}
