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
    _sb.writeln("List<RouteInformations> _routes = <RouteInformations>[");
    _routes.forEach((RouteInformationsGenerator route) {
      _sb.writeln(
          "new RouteInformations(\"${route.path}\", ${JSON.encode(route.methods)}),");
    });
    _sb.writeln("];");
    _sb.writeln("");

    _sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    _sb.writeln("List<String> args = <String>[];");
    _sb.writeln("bool match = false;");
    for (int i = 0; i < _routes.length; i++) {
      _sb.writeln(
          "match = _routes[$i].matchWithRequestPathAndMethod(args, request.uri.path, request.method);");
      _sb.writeln("if (match) {");
      String returnType = _callFunction(i);
      _executeResponse(returnType);
      _sb.writeln("return true;");
      _sb.writeln("}");
    }
    _sb.writeln("return null;");
    _sb.writeln("}");
    _sb.writeln("");

    _sb.writeln("}");
    return _sb.toString();
  }

  String _callFunction(int i) {
    String returnType;
    if (_routes[i].returnType.startsWith("Future")) {
      returnType = _getTypeFromFuture(_routes[i].returnType);
      _sb.write("$returnType result = await ${_routes[i].signature}(");
      _fillParameter(_routes[i].parameters);
      _sb.writeln(");");
    } else {
      if (_routes[i].returnType == "void") {
        _sb.write("${_routes[i].signature}(");
        _fillParameter(_routes[i].parameters);
        _sb.writeln(");");
      } else {
        returnType = _routes[i].returnType;
        _sb.write("$returnType result = ${_routes[i].signature}(");
        _fillParameter(_routes[i].parameters);
        _sb.writeln(");");
      }
    }
    return returnType;
  }

  void _executeResponse(String type) {
    if (type == "String") {
      _sb.writeln("int length = UTF8.encode(result).length;");
      _sb.writeln("request.response..contentLength = length..write(result);");
    }
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
