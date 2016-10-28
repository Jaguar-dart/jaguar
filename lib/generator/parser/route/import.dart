library jaguar.generator.parser.route;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar/generator/parser/interceptor/import.dart';

import 'package:jaguar/generator/parser/import.dart';

class RouteInfo {
  final MethodElement methodEl;

  final String pathPrefix;

  final ant.Route route;

  final List<InterceptorInfo> interceptors;

  final List<InputInfo> inputs;

  DartType get returnType => methodEl.returnType;

  bool get returnsVoid => returnType.isVoid;

  bool get returnsFuture => returnType.isDartAsyncFuture;

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
        if (!interc.matchesReturnType(param.type)) {
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
  return element.metadata.map((ElementAnnotation annot) {
    try {
      return instantiateAnnotation(annot);
    } catch (_) {
      //TODO check what exception and decide accordingly
      return null;
    }
  }).firstWhere((dynamic instance) => instance is ant.Route, orElse: null);
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
            .map((ElementAnnotation annot) {
              try {
                return instantiateAnnotation(annot);
              } catch (_) {
                //TODO check what exception and decide accordingly
                return null;
              }
            })
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
