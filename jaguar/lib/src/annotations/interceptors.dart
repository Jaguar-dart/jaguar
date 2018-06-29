part of jaguar.src.annotations;

class Intercept {
  final List<dynamic /* RouteInterceptor | Symbol */> before;
  final List<dynamic /* RouteInterceptor | Symbol */> after;
  final List<dynamic /* RouteInterceptor | Symbol */> onException;
  const Intercept(this.before,
      {this.after: const [], this.onException: const []});
}

class After {
  final List<RouteInterceptor> after;
  const After(this.after);
}

class OnException {
  final List<ExceptionHandler> onException;
  const OnException(this.onException);
}
