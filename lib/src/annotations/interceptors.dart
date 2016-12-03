part of jaguar.src.annotations;

/// Base class for interceptor
class Interceptor {
  /// Id of the interceptor
  final String id;

  final Map<Symbol, Type> params;

  const Interceptor({this.id, this.params});
}

/// Instantiates a parameter in constructor or method as non-constant instance
class InstantiateParam {
  const InstantiateParam();
}

class ProvideAsInterceptorResult {
  final Type asInterceptor;

  const ProvideAsInterceptorResult(this.asInterceptor);
}
