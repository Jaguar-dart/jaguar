part of jaguar.generator.writer;

class DefaultResponseWriterRaw {
  final RouteInfo route;

  DefaultResponseWriterRaw(this.route);

  String generate() {
    StringBuffer sb = new StringBuffer();

    if (route.isWebSocket) return "";

    if (route.route.statusCode is int) {
      sb.writeln("request.response.statusCode = " +
          route.route.statusCode.toString() +
          ";");
    } else {
      sb.writeln("request.response.statusCode = 200;");
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

    if (!route.returnsVoid) {
      if (route.defaultResponseWriter) {
        sb.writeln("request.response.write(rRouteResponse.toString());");
        sb.writeln("await request.response.close();");
      }
    }

    return sb.toString();
  }
}

class DefaultResponseWriterResponse {
  final RouteInfo route;

  DefaultResponseWriterResponse(this.route);

  String generate() {
    StringBuffer sb = new StringBuffer();

    sb.writeln("request.response.statusCode = rRouteResponse.statusCode??200;");

    sb.writeln('if (rRouteResponse.headers is Map) {');
    sb.writeln('  for (String key in rRouteResponse.headers.keys) {');
    sb.writeln(
        '    request.response.headers.add(key,rRouteResponse.headers[key]);');
    sb.writeln('  }');
    sb.writeln('}');

    if (route.defaultResponseWriter) {
      sb.writeln("request.response.write(rRouteResponse.valueAsString);");
      sb.writeln("await request.response.close();");
    }

    return sb.toString();
  }
}
