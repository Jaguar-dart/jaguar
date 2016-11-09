part of jaguar.generator.parser.interceptor;

/// Holds information about interceptor functions
class InterceptorFuncDef {
  /// The function or method element
  final MethodElementWrap _method;

  DartType get returnType => _method.returnType;

  bool get returnsVoid => returnType.isVoid;

  bool get returnsFuture => returnType.isDartAsyncFuture;

  DartType get returnsFutureFlattened {
    if (returnType == null) {
      return null;
    }

    if (!returnsFuture) {
      return returnType;
    }

    return returnType.flattenFutures(returnType.element.context.typeSystem);
  }

  /// Inputs declared on the interceptor
  List<Input> inputs = <Input>[];

  /// Default constructor. Constructs [InterceptorFuncDef] from the given
  /// method element
  InterceptorFuncDef(MethodElement aMethod)
      : _method = new MethodElementWrap(aMethod) {
    /// Initialize constant values
    _method.metadata
        .forEach((ElementAnnotation annot) => annot.computeConstantValue());

    /// Find and collect Inputs to the interceptor
    _method.metadata
        .map(createInput)
        .where((Input instance) => instance is Input)
        .forEach((Input inp) => inputs.add(inp));
  }

  bool get needsHttpRequest {
    if (_method.parameters.length < 1) {
      return false;
    }

    return _method.parameters[0].type.name ==
        "HttpRequest"; //TODO check which HttpRequest
  }

  int get _numDefaultInputs => needsHttpRequest ? 1 : 0;

  int get _allInputsLen => inputs.length + _numDefaultInputs;

  List<ParameterElement> get optionalParams => _method.optionalParameters;

  List<ParameterElement> get nonInputParams {
    if (_method.requiredParameters.length <= _allInputsLen) {
      return <ParameterElement>[];
    } else {
      return _method.requiredParameters.sublist(_allInputsLen);
    }
  }

  ParameterElementWrap get queryParamInjectionParam => nonInputParams
      .map((ParameterElement param) => new ParameterElementWrap(param))
      .firstWhere((ParameterElementWrap param) => param.name == 'queryParams',
          orElse: () => null);

  bool get needsQueryParamInjection => queryParamInjectionParam != null;

  bool get shouldKeepQueryParam {
    if (needsQueryParamInjection) {
      return true;
    }

    if (optionalParams.length != 0) {
      return true;
    }

    return false;
  }
}
