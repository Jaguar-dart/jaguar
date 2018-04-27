library jaguar_generator.writer;

import 'package:jaguar_generator/models/models.dart';

part 'exception.dart';

class Writer {
  Upper _u;

  Writer(this._u);

  List<Route> get _r => _u.routes;

  List<Group> get _g => _u.groups;

  String generate() {
    StringBuffer sb = new StringBuffer();
    sb.writeln("abstract class _\$${_u.name} implements RequestHandler {");

    sb.writeln(_writeRouteList());

    sb.writeln(_writeHandlerPrototypes());

    sb.writeln(_writeGroupDecl());

    sb.writeln(_writeReqHandler());

    sb.writeln('}');

    return sb.toString();
  }

  String _writeRouteList() {
    StringBuffer sb = new StringBuffer();

    sb.writeln("static const List<RouteBase> routes = const <RouteBase>[");
    String routeList = _r.map((Route route) => route.instantiation).join(',');
    sb.write(routeList);
    sb.writeln("];");

    return sb.toString();
  }

  String _writeHandlerPrototypes() {
    StringBuffer sb = new StringBuffer();
    for (Route r in _r) {
      if (r.method.isAsync) {
        sb.writeln('Future<${r.method.returnType}>');
      } else {
        sb.writeln('${r.method.returnType}');
      }
      sb.writeln('${r.method.name}(Context ctx);');
      sb.writeln();
    }
    for (String c in _u.interceptorMethods.keys) {
      sb.writeln('Interceptor $c(Context ctx);');
    }
    return sb.toString();
  }

  String _writeGroupDecl() {
    StringBuffer sb = new StringBuffer();

    _g.forEach((Group group) {
      sb.writeln('${group.type} get ${group.name};');
    });

    return sb.toString();
  }

  String _writeReqHandler() {
    StringBuffer sb = new StringBuffer();
    sb.writeln(kHandleReq);
    if (_u.prefix.isNotEmpty) {
      sb.writeln("prefix += '${_u.prefix}';");
    }

    if (_r.isNotEmpty) {
      sb.writeln("bool match = false;");
    }

    sb.writeln();

    for (int i = 0; i < _r.length; i++) {
      sb.writeln(_writeHandlerForRoute(_r[i], i));
    }

    _u.groups.forEach((Group group) {
      sb.writeln("{");
      sb.write("Response response = ");
      sb.write("await ${group.name}.handleRequest(ctx,prefix: prefix");
      if (group.path.isNotEmpty) {
        sb.write(" + '${group.path}'");
      }
      sb.writeln(");");

      sb.writeln("if (response is Response) {");
      sb.writeln("return response;");
      sb.writeln("}");
      sb.writeln("}");
      sb.writeln();
    });

    sb.writeln("return null;");
    sb.writeln("}");
    sb.writeln();
    return sb.toString();
  }

  String _writeHandlerForRoute(final Route route, final int i) {
    StringBuffer sb = new StringBuffer();
    sb.writeln('//Handler for ${route.method.name}');
    sb.writeln(
        "match = routes[$i].match(ctx.path, ctx.method, prefix, ctx.pathParams);");
    sb.writeln("if (match) {");

    if (route.exceptions.length != 0) {
      sb.writeln("try {");
    }

    if (route.interceptors.length > 0) {
      sb.writeln('final interceptors = <InterceptorCreator>[');
      for (InterceptorCreatorFunc interceptor in route.interceptors) {
        if (interceptor.isMember) {
          sb.writeln("this.${interceptor.name},");
        } else {
          if (interceptor.isStatic) {
            sb.writeln("${_u.baseName}.${interceptor.name},");
          } else {
            sb.writeln("${interceptor.name},");
          }
        }
      }
      sb.writeln('];');
      sb.writeln(
          "return await Interceptor.chain(ctx, interceptors, ${route.method
              .name}, routes[$i]);");
    } else {
      if (route.method.returnsResponse) {
        if (route.method.isAsync) {
          sb.writeln('return await ${route.method.name}(ctx);');
        } else {
          sb.writeln('return ${route.method.name}(ctx);');
        }
      } else {
        if (route.method.isAsync) {
          sb.writeln(
              'return new Response.fromRoute(await ${route.method.name}(ctx), routes[$i]);');
        } else {
          sb.writeln(
              'return new Response.fromRoute(${route.method.name}(ctx), routes[$i]);');
        }
      }
    }

    if (route.exceptions.length != 0) {
      sb.write('} catch(e, s) {');

      RouteExceptionWriter exceptWriter = new RouteExceptionWriter(route);
      sb.write(exceptWriter.generate());

      sb.writeln('rethrow;');

      sb.write('}');
    }

    sb.writeln("}");
    sb.writeln();

    return sb.toString();
  }
}

const String kHandleReq =
    "Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {";
