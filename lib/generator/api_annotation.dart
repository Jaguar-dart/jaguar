library jaguar.generator.api_class;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';

import 'processor.dart';
import 'pre_processor/pre_processor.dart';
import 'pre_processor/pre_processor_function.dart';
import 'post_processor/post_processor.dart';
import 'post_processor/post_processor_function.dart';
import 'writer.dart';
import 'route/route_information_generator.dart';
import 'route/route_information_processor.dart';
import 'parameter.dart';

class ApiAnnotationGenerator extends GeneratorForAnnotation<Api> {
  const ApiAnnotationGenerator();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, Api annotation, BuildStep buildStep) async {
    ClassElement classElement = element;
    String className = classElement.name;

    Writer w = new Writer(className);

    String prefix = "/";
    if (annotation.name.isNotEmpty && annotation.version.isNotEmpty) {
      prefix = "/${annotation.name}/${annotation.version}";
    }
    List<PreProcessor> preProcessors = <PreProcessor>[];
    List<PostProcessor> postProcessors = <PostProcessor>[];

    getMetadata(element, preProcessors, postProcessors);

    _groupRecursion(w, classElement, prefix, "", preProcessors, postProcessors);

    return w.toString();
  }

  void _groupRecursion(
      Writer w,
      ClassElement classElement,
      String prefix,
      String resource,
      List<PreProcessor> parentPreProcessors,
      List<PostProcessor> parentPostProcessors) {
    List<RouteInformationsGenerator> routes = getRouteInformationsGenerator(
        classElement,
        prefix,
        resource,
        parentPreProcessors,
        parentPostProcessors);

    w.addAllRoutes(routes);

    classElement.fields.forEach((FieldElement fieldElement) {
      Group group =
          getMetadata(fieldElement, parentPreProcessors, parentPostProcessors);
      List<PreProcessor> preProcessors = <PreProcessor>[]
        ..addAll(parentPreProcessors);
      List<PostProcessor> postProcessors = <PostProcessor>[]
        ..addAll(parentPostProcessors);

      _groupRecursion(w, fieldElement.type.element, "$prefix/${group.name}",
          '${fieldElement.displayName}.', preProcessors, postProcessors);
    });
  }

  dynamic getMetadata(Element element, List<PreProcessor> preProcessors,
      List<PostProcessor> postProcessors) {
    Processor processor;
    bool hasPassedProcessor = false;
    Map<String, int> numberTimeSamePreProcessor = <String, int>{};
    Map<String, int> numberTimeSamePostProcessor = <String, int>{};
    element.metadata.forEach((ElementAnnotation elementAnnotation) {
      var annotation = instantiateAnnotation(elementAnnotation);
      if (annotation is PreProcessor) {
        if (hasPassedProcessor) {
          throw "PreProcessor must be before Processor";
        }
        String type = annotation.runtimeType.toString();
        if (!numberTimeSamePreProcessor.containsKey(type)) {
          numberTimeSamePreProcessor[type] = 0;
        } else {
          if (!annotation.allowMultiple) {
            throw "PreProcessor ${annotation.functionName} doesn't allow you to call it multiple time";
          }
          numberTimeSamePreProcessor[type] += 1;
        }
        preProcessors.add(annotation);
      } else if (annotation is Processor) {
        processor = annotation;
        hasPassedProcessor = true;
      } else if (annotation is PostProcessor) {
        if (!hasPassedProcessor) {
          throw "PostProcessor must be after Processor";
        }
        String type = annotation.runtimeType.toString();
        if (!numberTimeSamePostProcessor.containsKey(type)) {
          numberTimeSamePostProcessor[type] = 0;
        } else {
          if (!annotation.allowMultiple) {
            throw "PostProcessor ${annotation.functionName} doesn't allow you to call it multiple time";
          }
          numberTimeSamePostProcessor[type] += 1;
        }
        // annotation.postProcessors.forEach(postProcessors.add);
        postProcessors.add(annotation);
      }
    });
    return processor;
  }

  List<RouteInformationsGenerator> getRouteInformationsGenerator(
          ClassElement classElement,
          String prefix,
          String resource,
          List<PreProcessor> parentPreProcessors,
          List<PostProcessor> parentPostProcessors) =>
      classElement.methods.map((MethodElement method) {
        List<PreProcessor> preProcessors = <PreProcessor>[]
          ..addAll(parentPreProcessors);
        List<PostProcessor> postProcessors = <PostProcessor>[]
          ..addAll(parentPostProcessors);
        Route route = getMetadata(method, preProcessors, postProcessors);
        List<Parameter> parameters = method.parameters
            .where((ParameterElement parameter) =>
                !parameter.parameterKind.isOptional)
            .map((ParameterElement parameter) => new Parameter(
                type: parameter.type.toString(), name: parameter.name))
            .toList();
        List<Parameter> namedParameters = method.parameters
            .where((ParameterElement parameter) =>
                parameter.parameterKind.isOptional)
            .map((ParameterElement parameter) => new Parameter(
                type: parameter.type.toString(), name: parameter.name))
            .toList();
        return new RouteInformationsGenerator(
            preProcessors,
            new RouteInformationsProcessor(
                path: "$prefix/${route.path}",
                methods: route.methods,
                parameters: parameters,
                namedParameters: namedParameters,
                returnType: method.returnType.toString(),
                functionName: "${resource}${method.displayName}"),
            postProcessors);
      });
}
