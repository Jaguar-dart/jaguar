library jaguar.generator.post_processor.post_processor_function;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'post_processor.dart';
import '../pre_processor/pre_processor.dart';
import '../pre_processor/pre_processor_function.dart';
import '../parameter.dart';

part 'post_processor_function.g.dart';

class PostProcessorFunction {
  final bool allowMultiple;
  final bool takeResponse;
  final List<String> preProcessors;

  const PostProcessorFunction(
      {this.allowMultiple: false,
      this.takeResponse: false,
      this.preProcessors: const <String>[]});
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

@PostProcessorFunction(
    allowMultiple: true, preProcessors: const <String>['OpenDbExample'])
Future<Null> closeDbExample(String _getDb) async {
  print("close $_getDb");
}
