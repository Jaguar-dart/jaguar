part of jaguar.generator.info;

class RouteInfo {
  final MethodElement methodEl;

  final String pathPrefix;

  final ant.Route route;

  final List<InterceptorInfo> interceptors;

  final List<InputInfo> inputs;

  RouteInfo(this.methodEl, this.route, this.interceptors, this.inputs,
      this.pathPrefix) {
    final int baseParamIndex = needsHttpRequest ? 1 : 0;

    if ((methodEl.parameters.length - baseParamIndex) < inputs.length) {
      throw new Exception("Inputs and parameters to route does not match!");
    }

    for (int index = 0; index < inputs.length; index++) {
      ParameterElement param = methodEl.parameters[baseParamIndex + index];
      InputInfo input = inputs[index];

      InterceptorInfo interc = interceptors.firstWhere((InterceptorInfo info) {
        if (info is DualInterceptorInfo) {
          return info.interceptor == input.resultFrom;
        } else {
          //TODO
        }
      }, orElse: () => null);

      if (interc == null) {
        throw new Exception("No matching interceptor!");
      }

      if (interc is DualInterceptorInfo) {
        //TODO fix Futures for interc return type
        if (interc.returnsD != param.type) {
          throw new Exception("Inputs and parameters to route does not match!");
        }
      }
      //TODO
    }
  }

  bool get needsHttpRequest {
    if (methodEl.parameters.length < 1) {
      return false;
    }

    return methodEl.parameters[0].type.name == "HttpRequest";
  }

  String get path => pathPrefix + route.path;

  String toString() {
    return "${route.path}";
  }

  Map<String, InterceptorInfo> _map = {};
}

ant.Route parseRoute(MethodElement element) {
  return element.metadata
      .map((ElementAnnotation annot) => instantiateAnnotation(annot))
      .firstWhere((dynamic instance) => instance is ant.Route, orElse: null);
}

List<RouteInfo> collectRoutes(ClassElement classElement, String prefix,
    List<InterceptorInfo> interceptorsParent) {
  return classElement.methods
      .map((MethodElement method) {
        ant.Route route = parseRoute(method);

        if (route == null) {
          return null;
        }

        List<InputInfo> inputs = method.metadata
            .map((ElementAnnotation annot) => instantiateAnnotation(annot))
            .where((dynamic instance) => instance is ant.Input)
            .map((ant.Input inp) => new InputInfo(inp.resultFrom))
            .toList();

        List<InterceptorInfo> interceptors = parseInterceptor(method);
        interceptors.insertAll(0, interceptorsParent);

        return new RouteInfo(method, route, interceptors, inputs, prefix);
      })
      .where((RouteInfo info) => info != null)
      .toList();
}
