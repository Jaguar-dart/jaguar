part of jaguar.src.annotations;

/// Annotation to wrap one interceptor around a route
class WrapOne {
  /// Symbol of the method on the RouteClass that creates the interceptor
  final dynamic /* Symbol | InterceptorCreator */ interceptor;

  const WrapOne(this.interceptor);
}

/// Annotation to wrap many interceptors around a route
class Wrap {
  /// Symbols of the methods on the RouteClass that create the interceptors
  final List<dynamic /* Symbol | InterceptorCreator */ > interceptors;

  const Wrap(this.interceptors);
}
