library jaguar.generators.writer;

import 'dart:convert';

import 'route.dart';
import 'processor.dart';
import 'pre_processor.dart';
import 'post_processor.dart';

class Writer {
  StringBuffer _sb;
  List<RouteInformationsGenerator> _routes;

  String className;

  Writer(this.className) {
    _sb = new StringBuffer();
    _routes = <RouteInformationsGenerator>[];
  }

  void addAllRoutes(List<RouteInformationsGenerator> routes) {
    _routes.addAll(routes);
  }

  String generate() {
    _sb.writeln("abstract class _\$Jaguar$className {");
    _sb.writeln("List<RouteInformations> _routes = <RouteInformations>[");
    _routes.forEach((RouteInformationsGenerator route) {
      _sb.writeln(
          "new RouteInformations(\"${route.processor.path}\", ${JSON.encode(route.processor.methods)}),");
    });
    _sb.writeln("];");
    _sb.writeln("");

    _generateProcessorFunction(_sb);

    _generateHandleApiRequest();

    _sb.writeln("}");

    return _sb.toString();
  }

  void _checkIfNeededAndAdd(
      Processor processor, List<String> processors, StringBuffer sb) {
    if (!processors.contains(processor.runtimeType.toString())) {
      processors.add(processor.runtimeType.toString());
      processor.dependsOn.forEach((PreProcessor dependOn) {
        if (!processors.contains(dependOn.runtimeType.toString())) {
          dependOn.generateFunction(sb);
          processors.add(dependOn.runtimeType.toString());
        }
      });
      processor.generateFunction(sb);
    }
  }

  void _generateProcessorFunction(StringBuffer sb) {
    List<String> preProcessors = <String>[];
    List<String> postProcessors = <String>[];
    for (int i = 0; i < _routes.length; i++) {
      _routes[i].preProcessor.forEach((PreProcessor preProcessor) {
        _checkIfNeededAndAdd(preProcessor, preProcessors, sb);
      });
      _routes[i].postProcessor.forEach((PostProcessor postProcessor) {
        _checkIfNeededAndAdd(postProcessor, postProcessors, sb);
      });
    }
  }

  void _generateHandleApiRequest() {
    _sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    _sb.writeln("List<String> args = <String>[];");
    _sb.writeln("bool match = false;");
    for (int i = 0; i < _routes.length; i++) {
      _sb.writeln(
          "match = _routes[$i].matchWithRequestPathAndMethod(args, request.uri.path, request.method);");
      _sb.writeln("if (match) {");

      _generatePreProcessor(_routes[i]);

      _generateProcessor(_routes[i]);

      _generatePostProcessor(_routes[i]);

      _sendResponse(_routes[i]);

      _sb.writeln("return true;");
      _sb.writeln("}");
    }
    _sb.writeln("return false;");
    _sb.writeln("}");
    _sb.writeln("");
  }

  void _generatePreProcessor(RouteInformationsGenerator route) {
    for (int j = 0; j < route.preProcessor.length; j++) {
      PreProcessor preProcessor = route.preProcessor[j];
      if (preProcessor.authorizedMethods
          .any((String method) => route.processor.methods.contains(method))) {
        _sb.write(preProcessor.generateCall());
      }
    }
  }

  void _generateProcessor(RouteInformationsGenerator route) {
    _sb.write(route.processor.generateCall());
  }

  void _generatePostProcessor(RouteInformationsGenerator route) {
    for (int i = 0; i < route.postProcessor.length; i++) {
      PostProcessor postProcessor = route.postProcessor[i];
      _sb.write(postProcessor.generateCall());
    }
  }

  _sendResponse(RouteInformationsGenerator route) {
    bool hasEncodeResponseToJson = route.postProcessor.any(
        (PostProcessor postProcessor) =>
            postProcessor.runtimeType.toString() ==
            'EncodeResponseToJsonPostProcessor');
    if (hasEncodeResponseToJson) {
      _sb.writeln("int length = UTF8.encode(response).length;");
      _sb.write("request.response");
      _sb.write("..headers.add('Content-Type', 'application/json')");
      _sb.write("..contentLength = length");
      _sb.writeln('..write(response);');
      return;
    }
    _sb.writeln("request.response.write(result);");
    return;
  }
}
