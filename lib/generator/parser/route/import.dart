library jaguar.generator.parser.route;

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar/generator/parser/interceptor/import.dart';

import 'package:jaguar/generator/parser/import.dart';
import 'package:jaguar/generator/internal/element/import.dart';
import 'package:jaguar/generator/parser/exception_handler/import.dart';

part 'route_info.dart';

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

List<RouteInfo> collectRoutes(
    ClassElement classElement,
    String prefix,
    List<InterceptorInfo> interceptorsParent,
    List<ExceptionHandlerInfo> exceptionHandlersParent) {
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

        List<ExceptionHandlerInfo> exceptions =
            collectExceptionHandlers(method);
        exceptions.insertAll(0, exceptionHandlersParent);

        return new RouteInfo(
            method, route, interceptors, inputs, exceptions, prefix);
      })
      .where((RouteInfo info) => info != null)
      .toList();
}
