library jaguar.generator.parser.route;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar/generator/parser/interceptor/import.dart';

import 'package:jaguar/generator/parser/import.dart';
import 'package:jaguar/generator/internal/element/import.dart';

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
    final int baseParamIndex = needsHttpRequest ? 1 : 0;

    if ((_method.parameters.length - baseParamIndex) < inputs.length) {
      throw new Exception("Inputs and parameters to route does not match!");
    }

    for (int index = 0; index < inputs.length; index++) {
      ParameterElement param = _method.parameters[baseParamIndex + index];
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

    return _method.parameters[0].type.name == "HttpRequest";
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
            .map(instantiateInputAnnotation)
            .where((InputInfo instance) => instance is InputInfo)
            .toList();

        List<InterceptorInfo> interceptors = parseInterceptor(method);
        interceptors.insertAll(0, interceptorsParent);

        return new RouteInfo(method, route, interceptors, inputs, prefix);
      })
      .where((RouteInfo info) => info != null)
      .toList();
}
