library jaguar.generator.hook.route_group;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar_generator/parser/parser.dart';
import 'package:jaguar_generator/validator/validator.dart';
import 'package:jaguar_generator/models/models.dart';
import 'package:jaguar_generator/to_model/to_model.dart';
import 'package:jaguar_generator/writer/writer.dart';

class ApiGenerator extends GeneratorForAnnotation<ant.Api> {
  const ApiGenerator();

  /// Generator
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader reader, BuildStep buildStep) async {
    if (element is! ClassElement) {
      throw new Exception("Api annotation can only be defined on a class.");
    }

    print(
        "Generating for Api class ${element.name} in ${buildStep.inputId} ...");

    // Parse source code
    final parsed = new ParsedUpper(element, reader.read('path').stringValue)
      ..parse();

    //Validate
    new ValidatorUpper(parsed)..validate();

    //Create model
    final toModel = new ToModelUpper(parsed);
    toModel.perform();
    Upper model = toModel.toModel();

    //Write
    String str = new Writer(model).generate();
    return str;
  }
}
