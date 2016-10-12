library jaguar.generator.api_generator;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';

import '../src/interceptors/interceptors.dart';
import 'pre_interceptors/pre_interceptor.dart';
//  ignore: unused_import
import 'pre_interceptors/function.dart';
import 'post_interceptors/post_interceptor.dart';
//  ignore: unused_import
import 'post_interceptors/function.dart';
import 'writer.dart';
import 'route_informations/generator.dart';
import 'route_informations/interceptor.dart';
import 'parameter.dart';

class ApiGenerator extends GeneratorForAnnotation<Api> {
  const ApiGenerator();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, Api annotation, BuildStep buildStep) async {
    ClassElement classElement = element;
    String className = classElement.name;

    Writer w = new Writer(className);

    String prefix = "";
    if (annotation.name.isNotEmpty && annotation.version.isNotEmpty) {
      prefix = "/${annotation.name}/${annotation.version}";
    }

    List<PreInterceptor> preInterceptors = _getPreInterceptorMetadata(element);
    List<PostInterceptor> postInterceptors =
        _getPostInterceptorMetadata(element);
    List<RouteInformationsGenerator> routesInterceptor = _groupRecursion(
        classElement, prefix, "", preInterceptors, postInterceptors);

    w.addAllRoutes(routesInterceptor);
    return w.toString();
  }

  List<PreInterceptor> _getPreInterceptorMetadata(Element element) =>
      element.metadata
          .map((ElementAnnotation elementAnnotation) {
            var annotation = instantiateAnnotation(elementAnnotation);
            if (annotation is PreInterceptor) {
              return annotation;
            }
            return null;
          })
          .where((annotation) => annotation != null)
          .toList();

  List<PostInterceptor> _getPostInterceptorMetadata(Element element) =>
      element.metadata
          .map((ElementAnnotation elementAnnotation) {
            var annotation = instantiateAnnotation(elementAnnotation);
            if (annotation is PostInterceptor) {
              return annotation;
            }
          })
          .where((annotation) => annotation != null)
          .toList();

  Route _getRouteMetadata(Element element) =>
      element.metadata.map((ElementAnnotation elementAnnotation) {
        var annotation = instantiateAnnotation(elementAnnotation);
        if (annotation is Route) {
          return annotation;
        }
      }).reduce((value, element) => value != null ? value : element);

  Group _getGroupMetadata(Element element) =>
      element.metadata.map((ElementAnnotation elementAnnotation) {
        var annotation = instantiateAnnotation(elementAnnotation);
        if (annotation is Group) {
          return annotation;
        }
      }).reduce((value, element) => value != null ? value : element);

  List<RouteInformationsGenerator> _groupRecursion(
      ClassElement classElement,
      String prefix,
      String resource,
      List<PreInterceptor> parentPreInterceptors,
      List<PostInterceptor> parentPostInterceptors) {
    List<RouteInformationsGenerator> routes = getRouteInformationsGenerator(
        classElement,
        prefix,
        resource,
        parentPreInterceptors,
        parentPostInterceptors);

    List<List<RouteInformationsGenerator>> nestedRoutes =
        classElement.fields.map((FieldElement fieldElement) {
      Group group = _getGroupMetadata(fieldElement);
      List<PreInterceptor> preInterceptors =
          _getPreInterceptorMetadata(fieldElement)
            ..addAll(parentPreInterceptors);
      List<PostInterceptor> postInterceptors =
          _getPostInterceptorMetadata(fieldElement)
            ..addAll(parentPostInterceptors);

      return _groupRecursion(
          fieldElement.type.element,
          "$prefix/${group.name}",
          '$resource${fieldElement.displayName}.',
          preInterceptors,
          postInterceptors);
    }).toList();

    List<RouteInformationsGenerator> allRoutes = <RouteInformationsGenerator>[]
      ..addAll(routes);
    nestedRoutes.forEach((List<RouteInformationsGenerator> resourceRoutes) {
      allRoutes.addAll(resourceRoutes);
    });

    return allRoutes;
  }

  List<RouteInformationsGenerator> getRouteInformationsGenerator(
          ClassElement classElement,
          String prefix,
          String resource,
          List<PreInterceptor> parentPreInterceptors,
          List<PostInterceptor> parentPostInterceptors) =>
      classElement.methods.map((MethodElement method) {
        Route route = _getRouteMetadata(method);
        List<PreInterceptor> preInterceptors =
            _getPreInterceptorMetadata(method)..addAll(parentPreInterceptors);
        List<PostInterceptor> postInterceptors =
            _getPostInterceptorMetadata(method)..addAll(parentPostInterceptors);
        List<Parameter> parameters = method.parameters
            .where((ParameterElement parameter) =>
                !parameter.parameterKind.isOptional)
            .map((ParameterElement parameter) => new Parameter(
                typeAsString: parameter.type.name, name: parameter.name))
            .toList();
        List<Parameter> namedParameters = method.parameters
            .where((ParameterElement parameter) =>
                parameter.parameterKind.isOptional)
            .map((ParameterElement parameter) => new Parameter(
                typeAsString: parameter.type.name, name: parameter.name))
            .toList();
        return new RouteInformationsGenerator(
            preInterceptors,
            new RouteInformationsInterceptor(
                path: "$prefix/${route.path}",
                methods: route.methods,
                parameters: parameters,
                namedParameters: namedParameters,
                returnType: method.returnType.toString(),
                functionName: "${resource}${method.displayName}"),
            postInterceptors);
      }).toList();
}
