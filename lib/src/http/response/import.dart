library jaguar.src.http.response;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as p;

part 'headers.dart';

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
  int statusCode = 200;

  /// HTTP headers
  final JaguarHttpHeaders headers = new JaguarHttpHeaders();

  /// HTTP cookies
  final List<Cookie> cookies = [];

  Response(this.value,
      {int statusCode: 200,
      Map<String, dynamic> headers: const {},
      String mimeType,
      String charset}) {
    if (statusCode is int) {
      this.statusCode = statusCode;
    }

    if (headers is Map) {
      headers.forEach((String name, String value) {
        this.headers.add(name, value);
      });
    }

    if (mimeType is String) this.headers.mimeType = mimeType;
    if (charset is String) this.headers.charset = charset;
  }

  /// Returns a `Response` object that performs a redirect
  static Response<Uri> redirect(/* Uri | String */ uri,
      {int statusCode: HttpStatus.SEE_OTHER}) {
    if (uri is String) uri = new Uri(path: uri);
    return new Response<Uri>(uri, statusCode: statusCode);
  }

  /// Encodes the given value to JSON and returns a `Response`
  static Response<String> json(dynamic data,
      {Response incoming,
      int statusCode: 200,
      Map<String, dynamic> headers: const {},
      String mimeType: 'application/json'}) {
    Response<String> ret;

    final String value = JSON.encode(data);

    if (incoming != null) {
      ret = new Response<String>.cloneExceptValue(incoming);
      ret.value = value;
    } else {
      ret =
          new Response<String>(value, statusCode: statusCode, headers: headers);
    }

    ret.headers.mimeType = mimeType;
    ret.headers.charset = 'utf-8';

    return ret;
  }

  static Response<String> xml(dynamic data,
      {Response incoming,
      int statusCode: 200,
      Map<String, dynamic> headers: const {},
      String mimeType: 'application/xml'}) {
    Response<String> ret;

    final String value = JSON.encode(data); //TODO encode with XML

    if (incoming != null) {
      ret = new Response<String>.cloneExceptValue(incoming);
      ret.value = value;
    } else {
      ret =
          new Response<String>(value, statusCode: statusCode, headers: headers);
    }

    ret.headers.mimeType = mimeType;
    ret.headers.charset = 'utf-8';

    return ret;
  }

  /// Clones another [Response] object except the value
  Response.cloneExceptValue(Response incoming) {
    statusCode = incoming.statusCode;
    incoming.headers.forEach((String key, dynamic val) {
      headers.add(key, val);
    });
    cookies.addAll(incoming.cookies);
  }

  /// Returns value as `String`
  String get valueAsString => value?.toString() ?? '';

  /// Writes body of the HTTP response from [value] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  Future writeResponse(HttpResponse resp) async {
    if (statusCode is int) {
      resp.statusCode = statusCode;
    }

    headers.forEach(resp.headers.set);

    resp.cookies.addAll(cookies);

    if (value is String) {
      resp.write(value);
    } else if (value is Stream<List<int>>) {
      await resp.addStream(value as Stream<List<int>>);
    } else if (value is List<int>) {
      resp.add(value as List<int>);
    } else if (value is Uri) {
      await resp.redirect(value as Uri, status: statusCode);
    } else {
      resp.write(valueAsString);
    }
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
