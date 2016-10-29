part of jaguar.generator.parser.route;

/// Parsed information about route
class RouteInfo {
  final MethodElementWrap _method;

  final String pathPrefix;

  final ant.Route route;

  final List<InterceptorInfo> interceptors;

  final List<InputInfo> inputs;

  DartType get returnType => _method.returnType;

  bool get returnsVoid => returnType.isVoid;

  bool get returnsFuture => returnType.isDartAsyncFuture;

  RouteInfo(MethodElement aMethod, this.route, this.interceptors, this.inputs,
      this.pathPrefix): _method = new MethodElementWrap(aMethod) {
    if (_method.requiredParameters.length < _allInputsLen) {
      throw new Exception("Inputs and parameters to route does not match!");
    }

    for (int index = 0; index < inputs.length; index++) {
      ParameterElement param = _method.requiredParameters[_numDefaultInputs + index];
      InputInfo input = inputs[index];

      InterceptorInfo interc = interceptors.firstWhere((InterceptorInfo info) {
        if (info is DualInterceptorInfo) {
          return input.resultFrom.hasType(info.interceptor) && input.id == info.id;
        } else {
          //TODO
        }
      }, orElse: () => null);

      if (interc == null) {
        throw new Exception("No matching interceptor!");
      }

      if (interc is DualInterceptorInfo) {
        if (!interc.matchesReturnType(param.type)) {
          throw new Exception("Inputs and parameters to route does not match!");
        }
      }
    }
  }

  bool get needsHttpRequest {
    if (_method.parameters.length < 1) {
      return false;
    }

    return _method.parameters[0].type.name == "HttpRequest";  //TODO check which HttpRequest
  }

  String get path => pathPrefix + route.path;

  String toString() {
    return "${route.path}";
  }

  String get prototype => _method.prototype;

  String get name => _method.name;

  DartType get returnTypeWithoutFuture => _method.returnTypeWithoutFuture;

  bool _defaultResponseWriter = true;

  bool get defaultResponseWriter => _defaultResponseWriter;

  int get _allInputsLen => inputs.length+_numDefaultInputs; //TODO param and query inputs

  int get _numDefaultInputs => needsHttpRequest ? 1 : 0;

  List<ParameterElement> get nonInputParams {
    if(_method.requiredParameters.length <= _allInputsLen) {
      return <ParameterElement>[];
    } else {
      return _method.requiredParameters.sublist(_allInputsLen);
    }
  }

  List<ParameterElement> get optionalParams => _method.optionalParameters;

  bool get areOptionalParamsPositional => _method.areOptionalParamsPositional;
}