library jaguar.generator.writer;

import 'dart:convert';

import 'pre_interceptors/pre_interceptor.dart';
import 'post_interceptors/post_interceptor.dart';
import 'route_informations/generator.dart';

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
          "new RouteInformations(r\"${route.routeInterceptor.path}\", ${JSON.encode(route.routeInterceptor.methods)}),");
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
          routes[i].routeInterceptor.returnType != "void" &&
          routes[i].routeInterceptor.returnType != "Future<Null>") {
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
    List<PreInterceptor> preProcessors = route.preInterceptors
        .where((PreInterceptor preProcessor) => preProcessor.methods.any(
            (String method) => route.routeInterceptor.methods.contains(method)))
        .toList();
    preProcessors.sort((PreInterceptor p1, PreInterceptor p2) {
      if (p1.variableName == null && p2.variableName != null) {
        return -1;
      }
      return 1;
    });
    Map<String, int> numberPreProcessor = <String, int>{};
    preProcessors.forEach((PreInterceptor preProcessor) {
      String type = preProcessor.runtimeType.toString();
      if (!numberPreProcessor.containsKey(type)) {
        numberPreProcessor[type] = 0;
      } else {
        numberPreProcessor[type] += 1;
      }
      preProcessor.callInterceptor(sb, numberPreProcessor[type]);
    });
  }

  void _generateProcessor(RouteInformationsGenerator route) {
    List<PreInterceptor> preProcessors = route.preInterceptors
        .where((PreInterceptor preProcessor) =>
            preProcessor.methods.any((String method) =>
                route.routeInterceptor.methods.contains(method)) &&
            preProcessor.variableName != null)
        .toList();
    ;
    sb.write(route.routeInterceptor.generateCall(preProcessors));
  }

  bool _generatePostProcessor(RouteInformationsGenerator route) {
    Map<String, int> numberPostProcessor = <String, int>{};
    bool someoneTakeTheResponse = false;
    route.postInterceptor.forEach((PostInterceptor postProcessor) {
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
      postProcessor.callInterceptor(sb, numberPostProcessor[type]);
    });
    numberPostProcessor.clear();
    route.preInterceptors.forEach((PreInterceptor preProcessor) {
      preProcessor.callPostInterceptorsAfter
          .forEach((PostInterceptor postProcessor) {
        String type = postProcessor.runtimeType.toString();
        if (!numberPostProcessor.containsKey(type)) {
          numberPostProcessor[type] = 0;
        } else {
          numberPostProcessor[type] += 1;
        }
        postProcessor.callInterceptor(sb, numberPostProcessor[type]);
      });
    });
    return someoneTakeTheResponse;
  }
}
