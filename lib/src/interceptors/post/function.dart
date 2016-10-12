library jaguar.src.interceptors.post;

import 'dart:io';
import 'dart:convert';

import '../../../generator/post_interceptors/function.dart';
import '../../../generator/post_interceptors/post_interceptor.dart';
import '../../../generator/parameter.dart';

part 'function.g.dart';

@PostInterceptorFunction(takeResponse: true)
void encodeStringToJson(HttpRequest request, String result) {
  int length = UTF8.encode(result).length;
  request.response
    ..headers.contentType = new ContentType("application", "json")
    ..contentLength = length
    ..write(result);
}

@PostInterceptorFunction(takeResponse: true)
void encodeMapOrListToJson(HttpRequest request, dynamic result) {
  encodeStringToJson(request, JSON.encode(result));
}
