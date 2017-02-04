library jaguar.src.http.response;

import 'dart:io';
import 'dart:async';

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

  Response(this.value, {int statusCode, Map<String, dynamic> headers}) {
    if (statusCode is int) {
      this.statusCode = statusCode;
    }

    if (headers is Map) {
      headers.forEach((String name, String value) {
        this.headers.add(name, value);
      });
    }
  }

  /// Clones another [Response] object except the value
  Response.cloneExceptValue(Response incoming) {
    statusCode = incoming.statusCode;
    incoming.headers.forEach((String key, dynamic val) {
      headers.add(key, val);
    });
    cookies.addAll(incoming.cookies);
  }

  String get valueAsString => value?.toString() ?? '';

  /// Writes body of the HTTP response from [value] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  Future writeResponse(HttpResponse resp) async {
    if (statusCode is int) {
      resp.statusCode = statusCode;
    }

    headers.forEach((String key, List<String> val) {
      val.forEach((String v) => resp.headers.add(key, v));
    });

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
