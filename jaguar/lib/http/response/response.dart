library jaguar.src.http.response;

import 'dart:async';
import 'dart:io';
import 'dart:convert' as cnv;
import 'package:jaguar/http/http.dart';

import 'package:jaguar/annotations/import.dart';

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
  int statusCode = 200;

  /// Headers
  final headers = JaguarHttpHeaders();

  /// Cookies
  final List<Cookie> cookies = [];

  Response(this.value,
      {this.statusCode: 200,
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

  static Response<String> json<ST>(ST value,
          {int statusCode: HttpStatus.ok,
          Map<String, dynamic> headers,
          String mimeType: MimeTypes.json,
          String charset}) =>
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
