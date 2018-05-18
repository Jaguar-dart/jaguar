part of jaguar.src.annotations;

class Intercept {
  final List<dynamic /* RouteInterceptor | Function */> before;
  final List<dynamic /* RouteInterceptor | Function */> after;
  final List<ExceptionHandler> onException;
  const Intercept(this.before,
      {this.after: const [], this.onException: const []});
}

class After {
  final List<dynamic /* RouteInterceptor | Function */> after;
  const After(this.after);
}

class OnException {
  final List<ExceptionHandler> onException;
  const OnException(this.onException);
}
