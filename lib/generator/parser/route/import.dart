library jaguar.generator.parser.route;

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar/generator/parser/interceptor/import.dart';

import 'package:jaguar/generator/parser/import.dart';
import 'package:jaguar/generator/internal/element/import.dart';
import 'package:jaguar/generator/parser/exception_handler/import.dart';

part 'route_info.dart';

ElementAnnotation parseRoute(MethodElement element) {
  return element.metadata.firstWhere((ElementAnnotation annot) {
    annot.computeConstantValue();
    try {
      return instantiateAnnotation(annot) is ant.Route;
    } catch (_) {
      return false;
    }
  }, orElse: () => null);
}

List<RouteInfo> collectRoutes(
    ClassElement classElement,
    String prefix,
    List<InterceptorInfo> interceptorsParent,
    List<ExceptionHandlerInfo> exceptionHandlersParent,
    List<String> groupNames) {
  return classElement.methods
      .map((MethodElement method) {
        ElementAnnotation routeAnnot = parseRoute(method);

        if (routeAnnot == null) {
          return null;
        }

        List<Input> inputs = method.metadata
            .map(createInput)
            .where((Input instance) => instance is Input)
            .toList();

        List<InterceptorInfo> interceptors = parseInterceptor(method);
        interceptors.insertAll(0, interceptorsParent);

        List<ExceptionHandlerInfo> exceptions =
            collectExceptionHandlers(method);
        exceptions.insertAll(0, exceptionHandlersParent);

        return new RouteInfo(method, routeAnnot, interceptors, inputs,
            exceptions, prefix, groupNames);
      })
      .where((RouteInfo info) => info != null)
      .toList();
}
