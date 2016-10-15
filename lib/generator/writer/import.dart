library jaguar.generator.writer;

import 'dart:convert';
import 'package:analyzer/dart/element/element.dart';

import 'package:jaguar/generator/info/import.dart';

String prototypeOfFunction(MethodElement method) {
  StringBuffer sb = new StringBuffer();
  sb.write(method.returnType.toString() + " ");
  sb.write(method.name + "(");
  method.parameters
      .forEach((ParameterElement pel) => sb.write(pel.toString() + ","));
  sb.writeln(");");
  return sb.toString();
}

class Writer {
  final String className;

  StringBuffer sb = new StringBuffer();

  final List<RouteInfo> routes = new List<RouteInfo>();

  Writer(this.className);

  void addAllRoutes(List<RouteInfo> newRoutes) {
    routes.addAll(newRoutes);
  }

  void generateClass() {
    sb.writeln("abstract class _\$Jaguar$className {");

    _writeRouteList();
    sb.writeln("");

    _writeRoutePrototype();
    sb.writeln("");

    _writeRequestHandler();

    sb.writeln("}");
  }

  void _writeRouteList() {
    sb.writeln("List<Route> _routes = <Route>[");
    routes.forEach((RouteInfo route) {
      final String path = route.path;
      final String methods = JSON.encode(route.route.methods);
      sb.writeln('new Route(r\"$path\", methods: $methods),');
    });
    sb.writeln("];");
  }

  void _writeRoutePrototype() {
    routes.forEach((RouteInfo route) {
      sb.writeln(prototypeOfFunction(route.methodEl));
      sb.writeln("");
    });
  }

  void _writeRequestHandler() {
    sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    sb.writeln("List<String> args = <String>[];");
    sb.writeln("bool match = false;");
    sb.writeln("");

    for (int i = 0; i < routes.length; i++) {
      sb.writeln(
          "match = _routes[$i].match(args, request.uri.path, request.method);");
      sb.writeln("if (match) {");

      _writePreInterceptors(routes[i]);

      _writeRouteCall(routes[i]);

      /* TODO
      _writePostProcessors(routes[i]);
      */

      sb.writeln("return true;");
      sb.writeln("}");
      sb.writeln("");
    }

    sb.writeln("return false;");
    sb.writeln("}");
    sb.writeln("");
  }

  void _writeRouteCall(RouteInfo route) {
    sb.write(route.methodEl.name + "(");

    if(route.needsHttpRequest) {
      sb.write("request, ");
    }

    route.inputs.forEach((InputInfo info) {
      sb.write("r" + info.resultFrom.toString() + ", ");
    });

    //TODO url parameter

    sb.writeln(");");
  }

  void _writePreInterceptors(RouteInfo route) {
    route.interceptors.forEach((InterceptorInfo info) {
      if (info is DualInterceptorInfo) {
        _writePreInterceptorDual(info);
      } else if (info is InterceptorFuncInfo) {
        if (!info.isPost) {
          _writePreInterceptorFunc(info);
        }
      }
    });
  }

  void _writePreInterceptorDual(DualInterceptorInfo info) {
    sb.write(info.returnsD.toString() + " ");
    sb.write("r" + info.interceptor.toString() + " = new ");
    sb.write(info.interceptor.toString() + "(");

    info.makeParams();
    //TODO
    sb.writeln(");");
  }

  void _writePreInterceptorFunc(InterceptorFuncInfo info) {
    if (info.isPost) {
      return;
    }

    //TODO
  }

  void _writePostProcessors(RouteInfo route) {
    //TODO
  }

  void _writePostProcessor() {
    //TODO
  }

  String toString() {
    generateClass();
    return sb.toString();
  }
}
