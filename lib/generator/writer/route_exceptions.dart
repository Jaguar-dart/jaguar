part of jaguar.generator.writer;

class RouteExceptionWriter {
  final RouteInfo route;

  RouteExceptionWriter(this.route);

  String generate() {
    StringBuffer sb = new StringBuffer();

    for (ExceptionHandlerInfo exception in route.exceptions) {
      sb.writeln(' on ${exception.exceptionName} catch(e, s) {');
      sb.write(exception.handlerName + ' handler = ');
      sb.writeln(exception.instantiationString + ';');

      //TODO what if its return type is Future
      sb.writeln('handler.onRouteException(request, e, s);');

      sb.write('return true;');

      sb.writeln('}');
    }

    return sb.toString();
  }
}
