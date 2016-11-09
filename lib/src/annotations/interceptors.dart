part of jaguar.src.annotations;

class DefineInterceptorFunc {
  const DefineInterceptorFunc();
}

/// Annotation to define a function as interceptor to a route
class InterceptorFunction {
  ///Function that contains the implementation of the interceptor
  final Function function;

  /// Defines if the interceptor should be executed pre or post route execution
  final bool isPost;

  const InterceptorFunction(this.function, {this.isPost: false});
}

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
