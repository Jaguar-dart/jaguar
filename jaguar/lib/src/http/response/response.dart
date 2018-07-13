library jaguar.src.http.response;

import 'dart:async';
import 'dart:io';
import 'dart:convert' as cnv;
import 'package:jaguar/src/http/http.dart';

import 'package:jaguar/src/annotations/import.dart';

export 'byte_response.dart';
export 'redirect_response.dart';
export 'stream_response.dart';

/// HTTP response. A route handler must respond to HTTP requests by producing a
/// [Response] object.
///
/// [ValueType] specializes the value contained by it.
///
/// [writeResponse] can be used to write response to underlying abstracted
/// response object.
class Response<ValueType> {
  /// Body of the response
  ValueType value;

  /// Status code of the response
  int statusCode;

  /// Headers
  final JaguarHttpHeaders headers = new JaguarHttpHeaders();

  /// Cookies
  final List<Cookie> cookies = [];

  Response(this.value,
      {this.statusCode: HttpStatus.ok,
      Map<String, dynamic> headers,
      String mimeType,
      String charset}) {
    if (headers != null)
      for (final String name in headers.keys) {
        this.headers.add(name, headers[name]);
      }

    if (mimeType != null) this.headers.mimeType = mimeType;
    if (charset != null) this.headers.charset = charset;
  }

  factory Response.fromRoute(dynamic value, HttpMethod route) => Response(
      route.responseProcessor != null ? route.responseProcessor(value) : value,
      statusCode: route.statusCode,
      mimeType: route.mimeType,
      charset: route.charset,
      headers: route.headers);

  static Response<String> json<ST>(ST value,
          {int statusCode: HttpStatus.ok,
          Map<String, dynamic> headers,
          String mimeType: MimeType.json,
          String charset: kDefaultCharset}) =>
      Response<String>(
        cnv.json.encode(value),
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType,
        charset: charset,
      );

  void writeAllButBody(HttpResponse resp) {
    resp.statusCode = statusCode;

    for (dynamic name in headers.headers.keys)
      resp.headers.set(name, headers.headers[name]);

    resp.cookies.addAll(cookies);
  }

  /// Writes body of the HTTP response from [value] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  FutureOr<void> writeResponse(HttpResponse resp) {
    writeAllButBody(resp);
    resp.write(value?.toString());
    return null;
  }
}

@Deprecated("Use Response('Result') instead.")
class StrResponse extends Response<String> {
  @Deprecated("Use Response('Result') instead.")
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
  @Deprecated("Use Response.json(json) instead.")
  StrResponse.json(dynamic value,
      {statusCode: 200,
      Map<String, dynamic> headers: const {},
      String mimeType: MimeType.json,
      String charset: kDefaultCharset})
      : this(
          cnv.json.encode(value),
          statusCode: statusCode,
          headers: headers,
          mimeType: mimeType,
          charset: charset,
        );

  /// Writes body of the HTTP response from [value] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  FutureOr<void> writeResponse(HttpResponse resp) {
    writeAllButBody(resp);
    resp.write(cnv.json.encode(value));
    return null;
  }
}
