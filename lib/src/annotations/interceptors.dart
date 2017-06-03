part of jaguar.src.annotations;

/// Annotation to wrap one interceptor around a route
class WrapOne {
  /// Symbol of the method on the RouteClass that creates the interceptor
  final Symbol interceptor;

  const WrapOne(this.interceptor);
}

/// Annotation to wrap many interceptors around a route
class Wrap {
  /// Symbol of the methods on the RouteClass that create the interceptors
  final List<Symbol> interceptors;

  const Wrap(this.interceptors);
}
