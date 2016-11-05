part of jaguar.src.annotations;

class DefineInterceptorFunc {
  const DefineInterceptorFunc();
}

///An annotation to add a function as interceptor to a route
class InterceptorFunction {
  ///Function that contains the implementation of the interceptor
  final Function function;

  final bool isPost;

  const InterceptorFunction(this.function, {this.isPost: false});
}

/// Defines a dual interceptor
class InterceptorClass {
  final bool writesResponse;

  const InterceptorClass({this.writesResponse: false});
}

/// Base class for dual interceptors
class Interceptor {
  final String id;

  const Interceptor({this.id});
}
