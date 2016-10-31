part of jaguar.generator.parser.route;

/// Parsed information about route
class RouteInfo {
  final MethodElementWrap _method;

  final String pathPrefix;

  final ant.Route route;

  final List<InterceptorInfo> interceptors;

  final List<InputInfo> inputs;

  final List<ExceptionHandlerInfo> exceptions;

  DartTypeWrap get returnType => new DartTypeWrap(_method.returnType);

  DartTypeWrap get returnTypeIntended => _method.returnTypeWithoutFuture;

  bool get returnsVoid => returnType.isVoid;

  bool get returnsResponse =>
      returnTypeIntended.compare('Response', 'jaguar.src.http.response');

  bool get returnsFuture => returnType.isDartAsyncFuture;

  Map<String, bool> _interceptorResultUsed = {};

  RouteInfo(MethodElement aMethod, this.route, this.interceptors, this.inputs,
      this.exceptions, this.pathPrefix)
      : _method = new MethodElementWrap(aMethod) {
    if (_method.requiredParameters.length < _allInputsLen) {
      throw new Exception("Inputs and parameters to route does not match!");
    }

    for (int index = 0; index < inputs.length; index++) {
      ParameterElement param =
          _method.requiredParameters[_numDefaultInputs + index];
      InputInfo input = inputs[index];
      _interceptorResultUsed[input.genName] = true;

      if (input.resultFrom.compare('RouteResponse', 'jaguar.src.annotations')) {
        continue;
      }

      InterceptorInfo interc = interceptors.firstWhere((InterceptorInfo info) {
        if (info is InterceptorClassInfo) {
          return input.resultFrom.isType(info.interceptor.type) &&
              input.id == info.id;
        } else {
          //TODO
        }
      }, orElse: () => null);

      if (interc == null) {
        throw new Exception("No matching interceptor!");
      }

      if (interc is InterceptorClassInfo) {
        if (!interc.matchesResultType(param.type)) {
          throw new Exception("Inputs and parameters to route does not match!");
        }
      }
    }

    interceptors.forEach((InterceptorInfo interc) {
      interc.inputs.forEach((InputInfo inp) {
        _interceptorResultUsed[inp.genName] = true;
      });

      if (interc.writesResponse) {
        if (_defaultResponseWriter == false) {
          throw new Exception('Route has more than one response writer!');
        }

        _defaultResponseWriter = false;
      }
    });
  }

  bool get needsHttpRequest {
    if (_method.parameters.length < 1) {
      return false;
    }

    return _method.parameters[0].type.name ==
        "HttpRequest"; //TODO check which HttpRequest
  }

  String get path => pathPrefix + route.path;

  String toString() {
    return "${route.path}";
  }

  String get prototype => _method.prototype;

  String get name => _method.name;

  bool _defaultResponseWriter = true;

  bool get defaultResponseWriter => _defaultResponseWriter;

  int get _numDefaultInputs => needsHttpRequest ? 1 : 0;

  int get _allInputsLen => inputs.length + _numDefaultInputs;

  List<ParameterElement> get nonInputParams {
    if (_method.requiredParameters.length <= _allInputsLen) {
      return <ParameterElement>[];
    } else {
      return _method.requiredParameters.sublist(_allInputsLen);
    }
  }

  List<ParameterElement> get optionalParams => _method.optionalParameters;

  bool get areOptionalParamsPositional => _method.areOptionalParamsPositional;

  ParameterElementWrap get pathParamInjectionParam => nonInputParams
      .map((ParameterElement param) => new ParameterElementWrap(param))
      .firstWhere((ParameterElementWrap param) => param.name == 'pathParams',
          orElse: () => null);

  bool get needsPathParamInjection => pathParamInjectionParam != null;

  ParameterElementWrap get queryParamInjectionParam => nonInputParams
      .map((ParameterElement param) => new ParameterElementWrap(param))
      .firstWhere((ParameterElementWrap param) => param.name == 'queryParams',
          orElse: () => null);

  bool get needsQueryParamInjection => queryParamInjectionParam != null;

  bool isDualInterceptorResultUsed(InterceptorClassInfo inter) =>
      _interceptorResultUsed.containsKey(inter.genReturnVarName);
}
