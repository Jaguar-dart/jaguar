library jaguar.generator.writer;

import 'dart:convert';

import 'pre_processor/pre_processor.dart';
import 'post_processor/post_processor.dart';
import 'route/route_information_generator.dart';

class Writer {
  final String className;
  StringBuffer sb;
  List<RouteInformationsGenerator> routes;

  Writer(this.className) {
    sb = new StringBuffer();
    routes = <RouteInformationsGenerator>[];
  }

  void addAllRoutes(List<RouteInformationsGenerator> newRoutes) {
    routes.addAll(newRoutes);
  }

  void generateClass() {
    sb.writeln("abstract class _\$Jaguar$className {");
    sb.writeln("List<RouteInformations> _routes = <RouteInformations>[");
    routes.forEach((RouteInformationsGenerator route) {
      sb.writeln(
          "new RouteInformations(r\"${route.routeProcessor.path}\", ${JSON.encode(route.routeProcessor.methods)}),");
    });
    sb.writeln("];");
    sb.writeln("");

    _generateHandleApiRequest();

    sb.writeln("}");
  }

  String toString() {
    generateClass();
    return sb.toString();
  }

  void _generateHandleApiRequest() {
    sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    sb.writeln("List<String> args = <String>[];");
    sb.writeln("bool match = false;");
    for (int i = 0; i < routes.length; i++) {
      sb.writeln(
          "match = _routes[$i].matchWithRequestPathAndMethod(args, request.uri.path, request.method);");
      sb.writeln("if (match) {");

      _generatePreProcessor(routes[i]);

      _generateProcessor(routes[i]);

      bool handleResponse = _generatePostProcessor(routes[i]);

      if (!handleResponse &&
          routes[i].routeProcessor.returnType != "void" &&
          routes[i].routeProcessor.returnType != "Future<Null>") {
        sb.write("request.response.write(result);");
      }

      sb.writeln("return true;");
      sb.writeln("}");
    }
    sb.writeln("return false;");
    sb.writeln("}");
    sb.writeln("");
  }

  void _generatePreProcessor(RouteInformationsGenerator route) {
    List<PreProcessor> preProcessors = route.preProcessors
        .where((PreProcessor preProcessor) => preProcessor.methods.any(
            (String method) => route.routeProcessor.methods.contains(method)))
        .toList();
    preProcessors.sort((PreProcessor p1, PreProcessor p2) {
      if (p1.variableName == null && p2.variableName != null) {
        return -1;
      }
      return 1;
    });
    Map<String, int> numberPreProcessor = <String, int>{};
    preProcessors.forEach((PreProcessor preProcessor) {
      String type = preProcessor.runtimeType.toString();
      if (!numberPreProcessor.containsKey(type)) {
        numberPreProcessor[type] = 0;
      } else {
        numberPreProcessor[type] += 1;
      }
      preProcessor.callProcessor(sb, numberPreProcessor[type]);
    });
  }

  void _generateProcessor(RouteInformationsGenerator route) {
    List<PreProcessor> preProcessors = route.preProcessors.where(
        (PreProcessor preProcessor) =>
            preProcessor.methods.any((String method) =>
                route.routeProcessor.methods.contains(method)) &&
            preProcessor.variableName != null);
    ;
    sb.write(route.routeProcessor.generateCall(preProcessors));
  }

  bool _generatePostProcessor(RouteInformationsGenerator route) {
    Map<String, int> numberPostProcessor = <String, int>{};
    bool someoneTakeTheResponse = false;
    route.postProcessor.forEach((PostProcessor postProcessor) {
      String type = postProcessor.runtimeType.toString();
      if (!numberPostProcessor.containsKey(type)) {
        numberPostProcessor[type] = 0;
      } else {
        numberPostProcessor[type] += 1;
      }
      if (!someoneTakeTheResponse) {
        someoneTakeTheResponse = postProcessor.takeResponse;
      } else if (someoneTakeTheResponse && postProcessor.takeResponse) {
        throw "Someone already take charge of sending the response";
      }
      postProcessor.callProcessor(sb, numberPostProcessor[type]);
    });
    numberPostProcessor.clear();
    route.preProcessors.forEach((PreProcessor preProcessor) {
      preProcessor.callPostProcessorsAfter
          .forEach((PostProcessor postProcessor) {
        String type = postProcessor.runtimeType.toString();
        if (!numberPostProcessor.containsKey(type)) {
          numberPostProcessor[type] = 0;
        } else {
          numberPostProcessor[type] += 1;
        }
        postProcessor.callProcessor(sb, numberPostProcessor[type]);
      });
    });
    return someoneTakeTheResponse;
  }
}
