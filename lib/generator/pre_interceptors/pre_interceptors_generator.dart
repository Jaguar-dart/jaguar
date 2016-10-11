library jaguar.generator.pre_processor_function_annotation_generator;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'pre_interceptor_function.dart';
import '../parameter.dart';

class PreInterceptorGenerator
    extends GeneratorForAnnotation<PreProcessorFunction> {
  const PreInterceptorGenerator();

  @override
  Future<String> generateForAnnotatedElement(FunctionElement element,
      PreProcessorFunction annotation, BuildStep buildStep) async {
    StringBuffer sb = new StringBuffer();

    List<Parameter> parameters = element.parameters
        .map((ParameterElement parameter) {
          if (parameter.type.name == 'HttpRequest') return null;
          return new Parameter(
              typeAsString: parameter.type.name,
              name: parameter.name,
              isOptional: true);
        })
        .where((Parameter parameter) => parameter != null)
        .toList();

    String className =
        "${element.displayName.substring(0, 1).toUpperCase()}${element.displayName.substring(1)}";

    sb.writeln("class $className extends PreProcessor {");
    parameters.forEach((Parameter parameter) {
      sb.writeln("final ${parameter.typeAsString} ${parameter.name};");
    });
    sb.writeln("");

    sb.write("const $className(");
    if (parameters.isNotEmpty) {
      _fillParameters(sb, parameters);
    }
    sb.write(") : super(");
    sb.write("returnType: '${element.returnType.toString()}',");
    if (element.returnType.toString() != "void" &&
        element.returnType.toString() != "Future<Null>") {
      sb.write("variableName: '_${element.displayName}',");
    }
    sb.write("functionName: '${element.displayName}',");
    sb.write("parameters: const <Parameter>[");
    element.parameters.forEach((ParameterElement parameter) {
      if (parameter.type.name == 'HttpRequest') {
        sb.write(
            "const Parameter(type: ${parameter.type.name}, name: '${parameter.name}'),");
      } else {
        sb.write(
            "const Parameter(type: ${parameter.type.name}, value: '${parameter.name}'),");
      }
    });
    sb.write("],");
    sb.write("methods: const <String>[");
    annotation.authorizedMethods.forEach((String method) {
      sb.write("'$method',");
    });
    sb.write("],");
    sb.write("allowMultiple: ${annotation.allowMultiple},");
    if (annotation.postProcessors.isNotEmpty) {
      sb.write("callPostProcessorsAfter: const <PostProcessor>[");
      annotation.postProcessors.forEach((Type postProcessor) {
        sb.write("const ${postProcessor.toString()}(),");
      });
      sb.write("]");
    }
    sb.writeln(");");

    sb.writeln("");

    if (parameters.isNotEmpty) {
      sb.writeln("@override");
      sb.writeln("void fillParameters(StringBuffer sb) {");

      element.parameters.forEach((ParameterElement parameter) {
        if (parameter.type.name == "HttpRequest") {
          sb.writeln("sb.writeln('${parameter.name},');");
        } else {
          sb.writeln("sb.writeln('\"\$${parameter.name}\",');");
        }
      });
      sb.writeln("}");
    }

    sb.writeln("}");

    return sb.toString();
  }

  void _fillParameters(StringBuffer sb, List<Parameter> parameters) {
    sb.write("{");
    parameters.forEach((Parameter parameter) {
      sb.write("this.${parameter.name},");
    });
    sb.write("}");
  }
}
