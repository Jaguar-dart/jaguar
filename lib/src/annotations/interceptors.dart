part of jaguar.src.annotations;

/// Base class for interceptor
class Interceptor {
  /// Id of the interceptor
  final String id;

  final Map<Symbol, MakeParam> params;

  const Interceptor({this.id, this.params});
}

class ProvideAsInterceptorResult {
  final Type asInterceptor;

  const ProvideAsInterceptorResult(this.asInterceptor);
}

abstract class MakeParam {
}

class MakeParamFromType implements MakeParam {
  final Type type;

  const MakeParamFromType(this.type);
}

/// Instantiates a parameter in constructor or method as non-constant instance
class MakeParamFromMethod implements MakeParam {
  final Symbol methodName;

  const MakeParamFromMethod([this.methodName]);
}

