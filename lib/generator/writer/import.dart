library jaguar.generator.writer;

import 'dart:convert';
import 'package:analyzer/dart/element/element.dart';

import 'package:jaguar/generator/parser/import.dart';
import 'package:jaguar/generator/internal/element/import.dart';

part 'pre_dual_inter.dart';
part 'post_dual_inter.dart';
part 'route_call.dart';
part 'route_exceptions.dart';
part 'default_response.dart';

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
    sb.writeln('');

    _writeRoutePrototype();
    sb.writeln('');

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
      sb.writeln(route.prototype);
      sb.writeln('');
    });
  }

  void _writeRequestHandler() {
    sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    sb.writeln("PathParams pathParams = new PathParams();");
    sb.writeln(
        "QueryParams queryParams = new QueryParams(request.uri.queryParameters);");
    sb.writeln("bool match = false;");
    sb.writeln("");

    for (int i = 0; i < routes.length; i++) {
      sb.writeln(
          "match = _routes[$i].match(request.uri.path, request.method, pathParams);");
      sb.writeln("if (match) {");

      _writePreInterceptors(routes[i]);

      _writeRouteCall(routes[i]);

      _writePostInterceptors(routes[i]);

      sb.writeln("return true;");
      sb.writeln("}");
      sb.writeln("");
    }

    sb.writeln("return false;");
    sb.writeln("}");
    sb.writeln("");
  }

  void _writeRouteCall(RouteInfo route) {
    if (!route.returnsVoid) {
      if (!route.returnsFuture) {
        sb.write(route.returnType.toString() + " rRouteResponse;");
      } else {
        sb.write(route.returnTypeWithoutFuture.toString() + " rRouteResponse;");
      }
    }

    if (route.exceptions.length != 0) {
      sb.writeln("try {");
    }

    RouteCallWriter callWriter = new RouteCallWriter(route);
    sb.write(callWriter.generate());

    if (route.exceptions.length != 0) {
      sb.write('} ');

      RouteExceptionWriter exceptWriter = new RouteExceptionWriter(route);
      sb.write(exceptWriter.generate());
    }

    if (route.returnsResponse) {
      DefaultResponseWriterResponse responseWriter =
          new DefaultResponseWriterResponse(route);
      sb.write(responseWriter.generate());
    } else {
      DefaultResponseWriterRaw responseWriter =
          new DefaultResponseWriterRaw(route);
      sb.write(responseWriter.generate());
    }
  }

  void _writePreInterceptors(RouteInfo route) {
    route.interceptors.forEach((InterceptorInfo info) {
      if (info is InterceptorClassInfo) {
        _writePreInterceptorClass(route, info);
      } else if (info is InterceptorFuncInfo) {
        if (!info.isPost) {
          _writePreInterceptorFunc(info);
        }
      }
    });
  }

  void _writePreInterceptorClass(RouteInfo route, InterceptorClassInfo info) {
    InterceptorFuncDef pre = info.dual.pre;

    sb.write(info.instantiationString);

    if (pre is! InterceptorFuncDef) {
      return;
    }

    InterceptorClassPreWriter preWriter =
        new InterceptorClassPreWriter(route, info);
    sb.write(preWriter.generate());
  }

  void _writePreInterceptorFunc(InterceptorFuncInfo info) {
    if (info.isPost) {
      return;
    }

    //TODO
  }

  void _writePostInterceptors(RouteInfo route) {
    route.interceptors.reversed.forEach((InterceptorInfo info) {
      if (info is InterceptorClassInfo) {
        _writePostInterceptorClass(route, info);
      } else if (info is InterceptorFuncInfo) {
        if (info.isPost) {
          _writePostInterceptorFunc(info);
        }
      }
    });
  }

  void _writePostInterceptorClass(RouteInfo route, InterceptorClassInfo info) {
    if (info.dual.post is! InterceptorFuncDef) {
      return;
    }

    InterceptorClassPostWriter writer =
        new InterceptorClassPostWriter(route, info);
    sb.write(writer.generate());
  }

  void _writePostInterceptorFunc(InterceptorFuncInfo info) {
    //TODO
  }

  String toString() {
    generateClass();
    return sb.toString();
  }
}

String _getStringTo(ParameterElementWrap param) {
  if (!param.type.isBuiltin) {
    throw new Exception("Can only convert builtin types!");
  }

  String ret = "stringTo";

  if (param.type.isInt) {
    ret += "Int";
  } else if (param.type.isDouble) {
    ret += "Double";
  } else if (param.type.isNum) {
    ret += "Num";
  } else if (param.type.isBool) {
    ret += "Bool";
  } else if (param.type.isString) {
    ret = "";
  } else {
    throw new Exception("Can only convert builtin types!");
  }

  return ret;
}
