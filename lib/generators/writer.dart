library source_gen_experimentation.generators.writer;

import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'route.dart';

class Writer {
  StringBuffer _sb;
  List<RouteInformationsGenerator> _routes;
  bool _needGetJsonFromBodyFunction;
  bool _needGetUtf8DataFunction;
  bool _needMustBeContentTypeFunction;

  String className;

  Writer(this.className) {
    _needGetJsonFromBodyFunction = false;
    _needGetUtf8DataFunction = false;
    _needMustBeContentTypeFunction = false;
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
      _prepareFunction(_routes[i]);
      String returnType = _callFunction(_routes[i]);
      _executeResponse(_routes[i], returnType);
      _sb.writeln("return true;");
      _sb.writeln("}");
    }
    _sb.writeln("return null;");
    _sb.writeln("}");
    _sb.writeln("");

    if (_needGetJsonFromBodyFunction) {
      _addGetJsonFromBody();
    }
    if (_needGetUtf8DataFunction) {
      _addGetUtf8Data();
    }
    if (_needMustBeContentTypeFunction) {
      _addMustBeContentType();
    }

    _sb.writeln("}");
    return _sb.toString();
  }

  void _addMustBeContentType() {
    _sb.writeln(
        "void mustBeContentType(HttpRequest request, ContentType contentType) {");
    _sb.writeln(
        "if (request.headers.contentType.value != contentType.value) {");
    _sb.writeln("String value = request.headers.contentType?.value ?? '';");
    _sb.writeln(
        "throw new BadRequestError('The request has content type \$value instead of \$contentType');");
    _sb.writeln("}");
    _sb.writeln(
        "if (contentType.charset != null && request.headers.contentType.charset != contentType.charset) {");
    _sb.writeln("String value = request.headers.contentType?.charset ?? '';");
    _sb.writeln(
        "throw new BadRequestError('The request has charset \$value instead of \${contentType.charset}');");
    _sb.writeln("}");
    _sb.writeln("}");
    _sb.writeln("");
  }

  void _addGetUtf8Data() {
    _sb.writeln("Future<String> getUtf8Data(HttpRequest request) async {");
    _sb.writeln("Completer<String> completer = new Completer<String>();");
    _sb.writeln("String datas = '';");
    _sb.writeln("request.transform(UTF8.decoder).listen((String data) {");
    _sb.writeln("datas += data;");
    _sb.writeln("}, onDone: () => completer.complete(datas)");
    _sb.writeln(
        ", onError: (dynamic error) => completer.completeError(error));");
    _sb.writeln("return completer.future;");
    _sb.writeln("}");
    _sb.writeln("");
  }

  void _addGetJsonFromBody() {
    _needGetUtf8DataFunction = true;
    _needMustBeContentTypeFunction = true;
    _sb.writeln(
        "Future<dynamic> _getJsonFromBody(HttpRequest request) async {");
    _sb.writeln("mustBeContentType(request, ContentType.JSON);");
    _sb.writeln("if (request.contentLength == 0) {");
    _sb.writeln("throw new BadRequestError('Your jons is empty');");
    _sb.writeln("}");
    _sb.writeln("String data = await getUtf8Data(request);");
    _sb.writeln("return JSON.decode(data);");
    _sb.writeln("}");
    _sb.writeln("");
  }

  void _prepareFunction(RouteInformationsGenerator route) {
    route.prepares.forEach((dynamic prepare) {
      if (prepare is DecodeBodyToJsonInformations) {
        _needGetJsonFromBodyFunction = true;
        if (prepare.encoding == 'utf-8') {
          _sb.writeln("var json = await _getJsonFromBody(request);");
        }
      }
    });
  }

  String _callFunction(RouteInformationsGenerator route) {
    String returnType;
    if (route.returnType.startsWith("Future")) {
      returnType = _getTypeFromFuture(route.returnType);
      _sb.write("$returnType result = await ${route.signature}(");
      _fillParameter(route.parameters);
      _sb.writeln(");");
    } else {
      if (route.returnType == "void") {
        _sb.write("${route.signature}(");
        _fillParameter(route.parameters);
        _sb.writeln(");");
      } else {
        returnType = route.returnType;
        _sb.write("$returnType result = ${route.signature}(");
        _fillParameter(route.parameters);
        _sb.writeln(");");
      }
    }
    return returnType;
  }

  void _executeResponse(RouteInformationsGenerator route, String type) {
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
          _sb.write("int.parse(args[${i++}]),");
        } else if (parameters[j].type.toString() == "double") {
          _sb.write("double.parse(args[${i++}]),");
        } else if (parameters[j].type.toString().startsWith("List") ||
            parameters[j].type.toString().startsWith("Map")) {
          _sb.write("json,");
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
