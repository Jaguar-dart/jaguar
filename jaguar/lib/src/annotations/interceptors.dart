part of jaguar.src.annotations;

class Intercept {
  final List<RouteFunc> before;
  final List<RouteFunc> after;
  final List<ExceptionHandler> onException;
  const Intercept(this.before,
      {this.after: const [], this.onException: const []});
}

class After {
  final List<RouteFunc> after;
  const After(this.after);
}

class OnException {
  final List<ExceptionHandler> onException;
  const OnException(this.onException);
}
