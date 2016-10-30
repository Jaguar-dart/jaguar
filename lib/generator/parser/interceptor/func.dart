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
  List<InputInfo> inputs = <InputInfo>[];

  /// Default constructor. Constructs [InterceptorFuncDef] from the given
  /// method element
  InterceptorFuncDef(MethodElement aMethod)
      : _method = new MethodElementWrap(aMethod) {
    /// Initialize constant values
    _method.metadata
        .forEach((ElementAnnotation annot) => annot.computeConstantValue());

    /// Find and collect Inputs to the interceptor
    _method.metadata
        .map(instantiateInputAnnotation)
        .where((InputInfo instance) => instance is InputInfo)
        .forEach((InputInfo inp) => inputs.add(inp));
  }

  /// Debug printer
  String toString() {
    String lRet = _method.name +
        '(' +
        inputs.map((InputInfo inp) => '$inp}').join(',') +
        ')';
    return lRet;
  }

  bool get needsHttpRequest {
    if (_method.parameters.length < 1) {
      return false;
    }

    return _method.parameters[0].type.name ==
        "HttpRequest"; //TODO check which HttpRequest
  }

  int get _numDefaultInputs => needsHttpRequest ? 1 : 0;

  int get _allInputsLen => inputs.length+_numDefaultInputs;

  List<ParameterElement> get nonInputParams {
    if(_method.requiredParameters.length <= _allInputsLen) {
      return <ParameterElement>[];
    } else {
      return _method.requiredParameters.sublist(_allInputsLen);
    }
  }
}

class InterceptorFuncInfo implements InterceptorInfo {
  InterceptorFuncDef definition;

  bool isPost;

  DartType result;

  List<InputInfo> inputs = <InputInfo>[];

  bool writesResponse;

  InterceptorFuncInfo(this.definition, {this.isPost: false});
}
