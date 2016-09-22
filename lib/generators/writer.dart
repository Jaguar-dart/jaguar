library source_gen_experimentation.generators.writer;

import 'dart:convert';

import 'route.dart';

class Writer {
  StringBuffer _sb;
  List<RouteInformationsGenrator> _routes;

  String className;

  Writer(this.className) {
    _sb = new StringBuffer();
    _routes = <RouteInformationsGenrator>[];
  }

  void addRoute(RouteInformationsGenrator route) {
    _routes.add(route);
  }

  String generate() {
    _sb.writeln("abstract class _\$Jaguar$className {");
    _sb.writeln("List<RouteInformations> _routes;");
    _sb.writeln("");

    _sb.writeln("void _initRoute() {");
    _sb.writeln("_routes = <RouteInformations>[];");
    _routes.forEach((RouteInformationsGenrator route) {
      _sb.writeln(
          "_addRoute(new RouteInformations(\"${route.path}\", ${JSON.encode(route.methods)}, ${route.signature}));");
    });
    _sb.writeln("}");
    _sb.writeln("");

    _sb.writeln("void _addRoute(RouteInformations route) {");
    _sb.writeln("_routes.add(route);");
    _sb.writeln("}");
    _sb.writeln("");

    _sb.writeln(
        "RouteInformations _getRoute(List<String> args, String path, String method) {");
    _sb.writeln("return _routes.firstWhere(");
    _sb.writeln(
        "(RouteInformations route) => route.matchWithRequestPathAndMethod(args, path, method),");
    _sb.writeln("orElse: () => null);");
    _sb.writeln("}");
    _sb.writeln("");

    _sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    _sb.writeln("if (_routes == null) _initRoute();");
    _sb.writeln("List<String> args = <String>[];");
    _sb.writeln(
        "RouteInformations route = _getRoute(args, request.uri.path, request.method);");
    _sb.writeln("if (route != null) {");
    _sb.writeln("if (args.isNotEmpty) await route.function(request, args);");
    _sb.writeln("else await route.function(request);");
    _sb.writeln("return true;");
    _sb.writeln("}");
    _sb.writeln("return false;");
    _sb.writeln("}");
    _sb.writeln("");

    _sb.writeln("}");
    return _sb.toString();
  }
}
