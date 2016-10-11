library jaguar.generator.post_processor.post_processor_function;

import 'dart:io';
import 'dart:convert';

import 'post_processor.dart';
import '../parameter.dart';

part 'post_processor_function.g.dart';

class PostProcessorFunction {
  final bool allowMultiple;
  final bool takeResponse;

  const PostProcessorFunction({
    this.allowMultiple: false,
    this.takeResponse: false,
  });
}

@PostProcessorFunction(takeResponse: true)
void encodeStringToJson(HttpRequest request, String result) {
  int length = UTF8.encode(result).length;
  request.response
    ..headers.contentType = new ContentType("application", "json")
    ..contentLength = length
    ..write(result);
}

@PostProcessorFunction(takeResponse: true)
void encodeMapOrListToJson(HttpRequest request, dynamic result) {
  encodeStringToJson(request, JSON.encode(result));
}
