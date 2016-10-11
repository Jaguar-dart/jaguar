library jaguar.generator.api_generator;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';

import '../src/interceptors/interceptors.dart';
import 'pre_interceptors/pre_interceptor.dart';
//  ignore: unused_import
import 'pre_interceptors/pre_interceptor_function.dart';
import 'post_interceptors/post_interceptor.dart';
//  ignore: unused_import
import 'post_interceptors/post_interceptor_function.dart';
import 'writer.dart';
import 'route/route_informations_generator.dart';
import 'route/route_informations_processor.dart';
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

    List<PreInterceptor> preProcessors = _getPreProcessorMetadata(element);
    List<PostInterceptor> postProcessors = _getPostProcessorMetadata(element);
    List<RouteInformationsGenerator> routesProcessor = _groupRecursion(
        classElement, prefix, "", preProcessors, postProcessors);

    w.addAllRoutes(routesProcessor);
    return w.toString();
  }

  List<PreInterceptor> _getPreProcessorMetadata(Element element) =>
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

  List<PostInterceptor> _getPostProcessorMetadata(Element element) =>
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
      List<PreInterceptor> parentPreProcessors,
      List<PostInterceptor> parentPostProcessors) {
    List<RouteInformationsGenerator> routes = getRouteInformationsGenerator(
        classElement,
        prefix,
        resource,
        parentPreProcessors,
        parentPostProcessors);

    List<List<RouteInformationsGenerator>> nestedRoutes =
        classElement.fields.map((FieldElement fieldElement) {
      Group group = _getGroupMetadata(fieldElement);
      List<PreInterceptor> preProcessors =
          _getPreProcessorMetadata(fieldElement)..addAll(parentPreProcessors);
      List<PostInterceptor> postProcessors =
          _getPostProcessorMetadata(fieldElement)..addAll(parentPostProcessors);

      return _groupRecursion(
          fieldElement.type.element,
          "$prefix/${group.name}",
          '$resource${fieldElement.displayName}.',
          preProcessors,
          postProcessors);
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
          List<PreInterceptor> parentPreProcessors,
          List<PostInterceptor> parentPostProcessors) =>
      classElement.methods.map((MethodElement method) {
        Route route = _getRouteMetadata(method);
        List<PreInterceptor> preProcessors = _getPreProcessorMetadata(method)
          ..addAll(parentPreProcessors);
        List<PostInterceptor> postProcessors = _getPostProcessorMetadata(method)
          ..addAll(parentPostProcessors);
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
            preProcessors,
            new RouteInformationsInterceptor(
                path: "$prefix/${route.path}",
                methods: route.methods,
                parameters: parameters,
                namedParameters: namedParameters,
                returnType: method.returnType.toString(),
                functionName: "${resource}${method.displayName}"),
            postProcessors);
      }).toList();
}
