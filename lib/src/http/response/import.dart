library jaguar.src.http.response;

import 'dart:io';
import 'dart:async';

part 'headers.dart';

class Response<ValueType> {
  ValueType value;

  int statusCode = 200;

  final JaguarHttpHeaders headers = new JaguarHttpHeaders();

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

  Response.cloneExceptValue(Response incoming) {
    statusCode = incoming.statusCode;
    incoming.headers.forEach((String key, dynamic val) {
      headers.add(key, val);
    });
    cookies.addAll(incoming.cookies);
  }

  String get valueAsString => value?.toString() ?? '';

  Future writeResponse(HttpResponse resp) async {
    if (statusCode is int) {
      resp.statusCode = statusCode;
    }

    headers.forEach((String key, List<String> val) {
      val.forEach((String v) => resp.headers.add(key, v));
    });

    resp.cookies.addAll(cookies);

    if (value is Stream<List<int>>) {
      await resp.addStream(value as Stream<List<int>>);
    } else if (value is List<int>) {
      await resp.add(value as List<int>);
    } else {
      resp.write(valueAsString);
    }
  }
}
