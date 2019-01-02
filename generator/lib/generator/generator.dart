library jaguar.generator.hook.route_group;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:jaguar/annotations/import.dart' as ant;

import 'package:jaguar_generator/parser/parser.dart';
import 'package:jaguar_generator/writer/writer.dart';

class ControllerGenerator extends GeneratorForAnnotation<ant.GenController> {
  const ControllerGenerator();

  /// Generator
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader reader, BuildStep buildStep) async {
    if (element is! ClassElement) {
      throw new Exception("Controllers have to be classes.");
    }

    print(
        "Generating for Controller ${element.name} in ${buildStep.inputId} ...");

    // Parse source code
    final model = parse(element);

    // Write
    String str = Writer(model).generate();
    return str;
  }
}

Builder jaguarPartBuilder({String header}) =>
    PartBuilder([ControllerGenerator()], '.jroutes.dart', header: header);
