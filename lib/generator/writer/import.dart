library jaguar.generator.writer;

import 'dart:convert';

import 'package:jaguar/generator/parser/import.dart';

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
      sb.writeln(route.prototype);
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
        sb.write(route.returnType.toString() + " ");
        sb.write("rResponse = ");
      } else {
        sb.write(route.returnTypeWithoutFuture.toString() + " ");
        sb.write("rResponse = await ");
      }
    }

    sb.write(route.name + "(");

    if (route.needsHttpRequest) {
      sb.write("request, ");
    }

    final String params =
        route.inputs.map((InputInfo info) => info.genName).join(", ");

    sb.write(params);

    //TODO url parameter

    sb.writeln(");");

    if (!route.returnsVoid) {
      print(route.name);
      if (route.route.statusCode is int) {
        sb.writeln("request.response.statusCode = " +
            route.route.statusCode.toString() +
            ";");
      }

      if (route.route.headers is Map) {
        Map<String, String> headers = route.route.headers;
        for (String key in headers.keys) {
          sb.write(r'request.response.headers.add("');
          sb.write(key);
          sb.write(r'", "');
          sb.write(headers[key]);
          sb.writeln(r'");');
        }
      }

      if (route.defaultResponseWriter) {
        sb.writeln("request.response..write(rResponse.toString())..close();");
      }
    }
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
    sb.write(info.interceptor.displayName + " ");
    sb.write(info.genInstanceName + " = ");
    sb.write(info.interceptor.instantiationString);
    sb.writeln(";");

    if (info.dual.pre is! InterceptorFuncDef) {
      return;
    }

    if (!info.returns.isVoid) {
      if (!info.returns.isDartAsyncFuture) {
        sb.write(info.returns.toString() + " ");
        sb.write(info.genReturnVarName + " = ");
      } else {
        sb.write(info.returns
                .flattenFutures(info.returns.element.context.typeSystem)
                .toString() +
            " ");
        sb.write(info.genReturnVarName + " = await ");
      }
    }

    sb.write(info.genInstanceName);
    sb.write(".pre(");
    final String params =
        info.dual.pre.inputs.map((InputInfo info) => info.genName).join(", ");
    sb.write(params);
    sb.writeln(");");
  }

  void _writePreInterceptorFunc(InterceptorFuncInfo info) {
    if (info.isPost) {
      return;
    }

    //TODO
  }

  void _writePostInterceptors(RouteInfo route) {
    route.interceptors.reversed.forEach((InterceptorInfo info) {
      if (info is DualInterceptorInfo) {
        _writePostInterceptorDual(info);
      } else if (info is InterceptorFuncInfo) {
        if (info.isPost) {
          _writePostInterceptorFunc(info);
        }
      }
    });
  }

  void _writePostInterceptorDual(DualInterceptorInfo info) {
    if (info.dual.post is! InterceptorFuncDef) {
      return;
    }

    if (!info.dual.post.returnsVoid) {
      if (info.dual.post.returnsFuture) {
        sb.write("await ");
      }
    }

    sb.write(info.genInstanceName);
    sb.write(".post(");
    final String params =
        info.dual.post.inputs.map((InputInfo info) => info.genName).join(", ");
    sb.write(params);
    sb.writeln(");");
  }

  void _writePostInterceptorFunc(InterceptorFuncInfo info) {
    //TODO
  }

  String toString() {
    generateClass();
    return sb.toString();
  }
}
