library jaguar.src.http.response;

import 'dart:async';
import 'dart:io';
import 'dart:convert' as cnv;
import 'package:jaguar/http/http.dart';
import 'package:jaguar/annotations/import.dart';

part 'byte_response.dart';
part 'redirect_response.dart';
part 'string_response.dart';
part 'stream_response.dart';

/// HTTP response. A route handler must respond to HTTP requests by producing a
/// [Response] object.
///
/// [ValueType] specializes the value contained by it.
///
/// [writeResponse] can be used to write response to underlying abstracted
/// response object.
abstract class Response<ValueType> {
  /// Body of the response
  ValueType? body;

  /// Status code of the response
  int statusCode = 200;

  /// Headers
  final headers = JaguarHttpHeaders();

  /// Cookies
  final List<Cookie> cookies = [];

  Response._make({
    this.body,
    this.statusCode = 200,
    Map<String, dynamic>? headers,
    String? mimeType,
    String? charset = kDefaultCharset,
    List<Cookie>? cookies,
  }) {
    if (headers != null)
      for (final String name in headers.keys) {
        this.headers.add(name, headers[name]);
      }

    if (mimeType != null) this.headers.mimeType = mimeType;
    if (charset != null) this.headers.charset = charset;

    if (cookies != null) {
      this.cookies.addAll(cookies);
    }
  }

  factory Response({
    dynamic? body,
    int statusCode = 200,
    Map<String, dynamic>? headers,
    String? mimeType,
    String? charset = kDefaultCharset,
    List<Cookie>? cookies,
  }) {
    return StringResponse(
        body: body?.toString(),
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType,
        charset: charset,
        cookies: cookies) as Response<ValueType>;
  }

  static StringResponse json<ST>(
    ST value, {
    dynamic serializeWith(ST value)?,
    int statusCode = HttpStatus.ok,
    Map<String, dynamic>? headers,
    String mimeType = MimeTypes.json,
    String charset = kDefaultCharset,
    List<Cookie>? cookies,
  }) {
    String body =
        cnv.json.encode(serializeWith == null ? value : serializeWith(value));
    return StringResponse(
      body: body,
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType,
      charset: charset,
      cookies: cookies,
    );
  }

  static StringResponse html(
    String html, {
    int statusCode = HttpStatus.ok,
    Map<String, dynamic>? headers,
    String mimeType = MimeTypes.html,
    String charset = kDefaultCharset,
    List<Cookie>? cookies,
  }) {
    return StringResponse(
      body: html,
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType,
      charset: charset,
      cookies: cookies,
    );
  }

  /// deleteCookie deletes a cookie with given [name]. Use [path] to specify
  /// the path from which the cookie has to be removed.
  void deleteCookie(String name, {String path = '/'}) {
    cookies.add(Cookie(name, '')
      ..expires = DateTime.now().subtract(_aDay)
      ..maxAge = -1
      ..path = path);
  }

  static const _aDay = Duration(days: 1);

  void writeAllButBody(HttpResponse resp) {
    resp.statusCode = statusCode;

    for (dynamic name in headers.headers.keys) {
      resp.headers.set(name, headers.headers[name]!);
    }

    resp.cookies.addAll(cookies);
  }

  /// Writes body of the HTTP response from [body] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  FutureOr<void> writeResponse(HttpResponse resp);
}

class SkipResponse extends Response {
  SkipResponse() : super._make();

  void writeResponse(HttpResponse resp) {}
}
