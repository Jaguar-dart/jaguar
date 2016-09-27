library source_gen_experimentation.generators.api_class;

import 'dart:async';
import 'dart:io';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';
import 'package:source_gen/src/utils.dart';
import 'package:jaguar/src/annotations.dart';

import 'writer.dart';
import 'route.dart';
import 'processor.dart';
import '../src/annotations.dart';

class GroupInformations {
  final String prefix;
  final String resourceName;

  GroupInformations(this.prefix, this.resourceName);
}

class ApiClassAnnotationGenerator extends GeneratorForAnnotation<Api> {
  const ApiClassAnnotationGenerator();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, Api annotation, BuildStep buildStep) async {
    if (element is! ClassElement) {
      var friendlyName = friendlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the Group annotation from `$friendlyName`.');
    }
    ClassElement classElement = element;
    String className = classElement.name;

    StringBuffer sb = new StringBuffer();
    sb.writeln("//\t$className ${annotation.name} ${annotation.version}");
    Writer writer = new Writer(className);

    List<PreProcessor> preProcessors = <PreProcessor>[];
    List<PostProcessor> postProcessors = <PostProcessor>[];
    bool hasPassedProcessor = false;

    element.metadata.forEach((ElementAnnotation annotation) {
      Processor processor = instantiateAnnotation(annotation);

      if (processor is PreProcessor) {
        _addPreProcessor(processor, preProcessors, hasPassedProcessor);
      } else if (processor is PostProcessor) {
        _addPostProcessor(processor, postProcessors, hasPassedProcessor);
      }

      if (processor is Api) {
        hasPassedProcessor = true;
      }
    });

    String prefix = "/";
    if (annotation.name.isNotEmpty && annotation.version.isNotEmpty) {
      prefix += "${annotation.name}/${annotation.version}";
    }

    await _groupRecursion(
        classElement, writer, prefix, "", preProcessors, postProcessors);

    return writer.generate();
  }

  void _addPreProcessor(PreProcessor preProcessor,
      List<PreProcessor> preProcessors, bool hasPassedProcessor) {
    if (hasPassedProcessor) {
      throw "Your pre processor need to be before the route";
    }
    if (preProcessor is DecodeBodyToJson) {
      DecodeBodyToJson decode = preProcessor;
      if (decode.charset == 'utf-8' || decode.charset == '') {
        ContentType contentType;
        if (decode.charset == '') {
          contentType = ContentType.parse("${decode.contentType}");
        } else {
          contentType = ContentType
              .parse("${decode.contentType}; charset=${decode.charset}");
        }
        preProcessors.add(
            new DecodeBodyToJsonInUtf8PreProcessor(contentType: contentType));
      }
    } else if (preProcessor is MustBeContentType) {
      MustBeContentType contentTypeAnnotation = preProcessor;
      preProcessors.add(new MustBeContentTypePreProcessor(
          contentType: contentTypeAnnotation.contentType));
    } else if (preProcessor is GetRawDataFromBody) {
      GetRawDataFromBody getDataFromBody = preProcessor;
      if (getDataFromBody.encoding == 'utf-8') {
        preProcessors.add(new GetDataFromBodyInUtf8PreProcessor());
      }
    } else {
      preProcessors.add(preProcessor);
    }
  }

  void _addPostProcessor(PostProcessor postProcessor,
      List<PostProcessor> postProcessors, bool hasPassedProcessor) {
    if (!hasPassedProcessor) {
      throw "Your post processor need to be after the route";
    }
    if (postProcessor is EncodeResponseToJson) {
      postProcessors.add(new EncodeResponseToJsonPostProcessor());
    } else {
      postProcessors.add(postProcessor);
    }
  }

  RouteInformationsGenerator _getMethodInformations(
      MethodElement method,
      String prefix,
      String resourceName,
      List<PreProcessor> parentPreProcessor,
      List<PostProcessor> parentPostProcessor) {
    bool hasPassedProcessor = false;

    List<PreProcessor> preProcessors = <PreProcessor>[]
      ..addAll(parentPreProcessor);
    RouteInformationsProcessor routeInformationsProcessor;
    List<PostProcessor> postProcessors = <PostProcessor>[]
      ..addAll(parentPostProcessor);

    method.metadata.forEach((ElementAnnotation annotation) {
      Processor processor = instantiateAnnotation(annotation);

      if (processor is PreProcessor) {
        _addPreProcessor(processor, preProcessors, hasPassedProcessor);
      } else if (processor is PostProcessor) {
        _addPostProcessor(processor, postProcessors, hasPassedProcessor);
      }

      if (processor is Route && !hasPassedProcessor) {
        hasPassedProcessor = true;
        Route route = processor;
        List<Parameter> parameters = <Parameter>[];
        List<Parameter> namedParameters = <Parameter>[];
        method.parameters.forEach((ParameterElement parameter) {
          if (!parameter.parameterKind.isOptional) {
            parameters.add(new Parameter(
                parameter.type.toString(), parameter.displayName));
          } else {
            namedParameters.add(new Parameter(
                parameter.type.toString(), parameter.displayName));
          }
        });
        routeInformationsProcessor = new RouteInformationsProcessor(
            path: "$prefix/${route.path}",
            methods: route.methods,
            preProcessorVariableName: preProcessors
                .map((PreProcessor preProcessor) {
                  if (preProcessor.variableName == null) return null;
                  return preProcessor.variableName;
                })
                .where((String variableName) => variableName != null)
                .toList(),
            functionName: method.displayName,
            returnType: method.returnType.toString(),
            parameters: parameters,
            namedParameters: namedParameters);
      }
    });
    return new RouteInformationsGenerator(
        preProcessors, routeInformationsProcessor, postProcessors);
  }

  Future<Null> _groupRecursion(ClassElement classElement, Writer writer,
      [String prefix = '',
      String resourceName = '',
      List<PreProcessor> parentPreProcessors = const [],
      List<PostProcessor> parentPostProcessors = const []]) async {
    List<RouteInformationsGenerator> routes = classElement.methods
        .map((MethodElement method) => _getMethodInformations(method, prefix,
            resourceName, parentPreProcessors, parentPostProcessors))
        .toList();

    writer.addAllRoutes(routes);

    for (int i = 0; i < classElement.fields.length; i++) {
      FieldElement fieldElement = classElement.fields[i];
      bool hasPassedProcessor = false;
      List<PreProcessor> preProcessors = <PreProcessor>[]
        ..addAll(parentPreProcessors);
      Group group;
      List<PostProcessor> postProcessors = <PostProcessor>[]
        ..addAll(parentPostProcessors);

      fieldElement.metadata.forEach((ElementAnnotation annotation) {
        Processor processor = instantiateAnnotation(annotation);

        if (processor is PreProcessor) {
          _addPreProcessor(processor, preProcessors, hasPassedProcessor);
        } else if (processor is PostProcessor) {
          _addPostProcessor(processor, postProcessors, hasPassedProcessor);
        }

        if (matchAnnotation(Group, annotation)) {
          hasPassedProcessor = true;
          group = instantiateAnnotation(annotation);
        }
      });
      if (hasPassedProcessor) {
        await _groupRecursion(
            fieldElement.type.element,
            writer,
            "$prefix/${group.path}",
            fieldElement.displayName,
            preProcessors,
            postProcessors);
      }
    }
  }

  String toString() => 'ApiClass';
}
