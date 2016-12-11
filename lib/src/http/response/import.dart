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

  String get valueAsString => value?.toString() ?? '';

  Future writeResponse(HttpResponse resp) async {
    if (statusCode is int) {
      resp.statusCode = statusCode;
    }

    headers.forEach((String key, List<String> val) {
      resp.headers.add(key, val);
    });

    resp.cookies.addAll(cookies);

    resp.write(valueAsString);
  }
}

/*
class Request extends StreamView<List<int>> implements HttpRequest {
  final HttpRequest _wrapped;

  Request(HttpRequest wrapped): _wrapped = wrapped, super(wrapped);

  int get contentLength => _wrapped.contentLength;

  String get method => _wrapped.method;

  Uri get uri => _wrapped.uri;

  Uri get requestedUri => _wrapped.requestedUri;

  HttpHeaders get headers => _wrapped.headers;

  List<Cookie> get cookies => _wrapped.cookies;

  bool get persistentConnection => _wrapped.persistentConnection;

  X509Certificate get certificate => _wrapped.certificate;

  HttpSession get session => _wrapped.session;

  String get protocolVersion => _wrapped.protocolVersion;

  HttpConnectionInfo get connectionInfo => _wrapped.connectionInfo;

  HttpResponse get response => _wrapped.response;
}
*/
