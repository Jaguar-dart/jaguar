library source_gen_experimentation.generators.writer;

import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'route.dart';

class Writer {
  StringBuffer _sb;
  List<RouteInformationsGenerator> _routes;

  String className;

  Writer(this.className) {
    _sb = new StringBuffer();
    _routes = <RouteInformationsGenerator>[];
  }

  void addRoute(RouteInformationsGenerator route) {
    _routes.add(route);
  }

  String generate() {
    _sb.writeln("abstract class _\$Jaguar$className {");
    // _sb.writeln("List<RouteInformations> _routes;");
    _sb.writeln("List<RouteInformations> _routes = <RouteInformations>[");
    _routes.forEach((RouteInformationsGenerator route) {
      _sb.writeln(
          "new RouteInformations(\"${route.path}\", ${JSON.encode(route.methods)}),");
    });
    _sb.writeln("];");
    _sb.writeln("");

    // _sb.writeln("void _initRoute() {");
    // _sb.writeln("_routes = <RouteInformations>[];");
    // _routes.forEach((RouteInformationsGenerator route) {
    //   _sb.writeln(
    //       "_addRoute(new RouteInformations(\"${route.path}\", ${JSON.encode(route.methods)}));");
    // });
    // _sb.writeln("}");
    // _sb.writeln("");

    // _sb.writeln("void _addRoute(RouteInformations route) {");
    // _sb.writeln("_routes.add(route);");
    // _sb.writeln("}");
    // _sb.writeln("");

    // _sb.writeln(
    //     "RouteInformations _getRoute(List<String> args, String path, String method) {");
    // _sb.writeln("return _routes.firstWhere(");
    // _sb.writeln(
    //     "(RouteInformations route) => route.matchWithRequestPathAndMethod(args, path, method),");
    // _sb.writeln("orElse: () => null);");
    // _sb.writeln("}");
    // _sb.writeln("");

    // _sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    // _sb.writeln("if (_routes == null) _initRoute();");
    // _sb.writeln("List<String> args = <String>[];");
    // _sb.writeln(
    //     "RouteInformations route = _getRoute(args, request.uri.path, request.method);");
    // _sb.writeln("if (route != null) {");
    // _sb.writeln("if (args.isNotEmpty) await route.function(request, args);");
    // _sb.writeln("else await route.function(request);");
    // _sb.writeln("return true;");
    // _sb.writeln("}");
    // _sb.writeln("return false;");
    // _sb.writeln("}");
    // _sb.writeln("");

    _sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    // _sb.writeln("if (_routes == null) _initRoute();");
    _sb.writeln("List<String> args = <String>[];");
    _sb.writeln("bool match = false;");
    for (int i = 0; i < _routes.length; i++) {
      _sb.writeln(
          "match = _routes[$i].matchWithRequestPathAndMethod(args, request.uri.path, request.method);");
      _sb.writeln("if (match) {");
      String type;
      if (_routes[i].returnType.startsWith("Future")) {
        type = _getTypeFromFuture(_routes[i].returnType);
        _sb.write("$type result = await ${_routes[i].signature}(");
        _fillParameter(_routes[i].parameters);
        _sb.writeln(");");
      } else {
        if (_routes[i].returnType == "void") {
          _sb.write("${_routes[i].signature}(");
          _fillParameter(_routes[i].parameters);
          _sb.writeln(");");
        } else {
          type = _routes[i].returnType;
          _sb.write("$type result = ${_routes[i].signature}(");
          _fillParameter(_routes[i].parameters);
          _sb.writeln(");");
        }
      }
      if (type == "String" || type == "var") {
        _sb.writeln("int length = UTF8.encode(result).length;");
        _sb.writeln("request.response..contentLength = length..write(result);");
      }
      _sb.writeln("return true;");
      _sb.writeln("}");
    }
    _sb.writeln("return null;");
    _sb.writeln("}");
    _sb.writeln("");

    _sb.writeln("}");
    return _sb.toString();
  }

  String _getTypeFromFuture(String returnType) {
    RegExp regExp = new RegExp("^Future<([A-Za-z]+)>\$");
    Iterable<Match> matchs = regExp.allMatches(returnType);
    if (matchs.isEmpty) {
      return "var";
    }
    return matchs.first.group(1);
  }

  void _fillParameter(List<ParameterElement> parameters) {
    int i = 0;
    for (int j = 0; j < parameters.length; j++) {
      if (!parameters[j].parameterKind.isOptional) {
        if (parameters[j].type.toString() == "HttpRequest") {
          _sb.write("request,");
        } else if (parameters[j].type.toString() == "String") {
          _sb.write("args[${i++}],");
        } else if (parameters[j].type.toString() == "int") {
          _sb.write("int.parse(args[${i++}])");
        } else if (parameters[j].type.toString() == "double") {
          _sb.write("double.parse(args[${i++}])");
        }
      } else {
        if (parameters[j].type.toString() == "String") {
          _sb.write(
              "${parameters[j].name}: request.requestedUri.queryParameters['${parameters[j].name}'],");
        } else if (parameters[j].type.toString() == "int") {
          _sb.write(
              "${parameters[j].name}: int.parse(request.requestedUri.queryParameters['${parameters[j].name}']),");
        } else if (parameters[j].type.toString() == "double") {
          _sb.write(
              "${parameters[j].name}: double.parse(request.requestedUri.queryParameters['${parameters[j].name}']),");
        }
      }
    }
  }
}
