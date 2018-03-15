part of jaguar_generator.writer;

class RouteExceptionWriter {
  final Route route;

  RouteExceptionWriter(this.route);

  String generate() {
    StringBuffer sb = new StringBuffer();

    for (ExceptionHandler exception in route.exceptions) {
      sb.writeln('{');
      sb.write(exception.handlerName + ' handler = ');
      sb.writeln(exception.instantiationString + ';');

      sb.writeln('final exResp = await handler.onRouteException(ctx, e, s);');
      sb.writeln('if(exResp != null) return exResp;');

      sb.writeln('}');
    }

    return sb.toString();
  }
}
