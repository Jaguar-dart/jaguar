part of jaguar.src.annotations;

/// Annotation to wrap one interceptor around a route
class WrapOne<OutputType, ResponseType, InResponseType> {
  /// Symbol of the method on the RouteClass that creates the interceptor
  final InterceptorCreator<OutputType, ResponseType, InResponseType>
      interceptor;

  const WrapOne(this.interceptor);
}

/// Annotation to wrap many interceptors around a route
class Wrap {
  /// Symbols of the methods on the RouteClass that create the interceptors
  final List<InterceptorCreator> interceptors;

  const Wrap(this.interceptors);
}
