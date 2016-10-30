part of jaguar.generator.writer;

class DefaultResponseWriter {
  final RouteInfo route;

  DefaultResponseWriter(this.route);

  String generate() {
    StringBuffer sb = new StringBuffer();

    if (!route.returnsVoid) {
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
        sb.writeln("request.response.write(rResponse.toString());");
        sb.writeln("await request.response.close();");
      }
    }

    return sb.toString();
  }
}
