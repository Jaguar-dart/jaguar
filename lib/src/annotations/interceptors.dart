part of jaguar.src.annotations;

/// Annotation to defines an interceptor class
class InterceptorClass {
  /// Defines if the interceptor writes response
  ///
  /// Only one interceptor can write response in an interceptor chain
  final bool writesResponse;

  const InterceptorClass({this.writesResponse: false});
}

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