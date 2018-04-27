library jaguar.generator.exceptions;

class ExceptionOnUpper {
  String upper;
}

class ExceptionOnRoute extends ExceptionOnUpper {
  String route;
}

class RouteException extends ExceptionOnRoute {
  final String message;

  RouteException(this.message);

  String toString() {
    StringBuffer sb = new StringBuffer();

    sb.writeln('Message: $message');
    sb.writeln('RequestHandler: $upper');
    sb.writeln('Route: $route');

    return sb.toString();
  }
}

class InputException extends ExceptionOnRoute {
  final String message;

  String onInterceptor;

  String param;

  InputException(this.message);

  String toString() {
    StringBuffer sb = new StringBuffer();

    sb.writeln('Message: $message');
    sb.writeln('RequestHandler: $upper');
    if (route is! String) {
      sb.writeln('Route: $route');
    }
    if (onInterceptor is! String) {
      sb.writeln('On interceptor: $onInterceptor');
    }
    if (param is! String) {
      sb.writeln('On param: $param');
    }

    return sb.toString();
  }
}

class InterceptorWrapParamException extends ExceptionOnRoute {
  final String message;

  String interceptor;

  String param;

  String on;

  InterceptorWrapParamException(this.message);

  String toString() {
    StringBuffer sb = new StringBuffer();

    sb.writeln('Message: $message');
    sb.writeln('RequestHandler: $upper');
    sb.writeln('Route: $route');
    sb.writeln('Interceptor: $interceptor');
    sb.writeln('Param: $param');
    sb.writeln('On: $on');

    return sb.toString();
  }
}
