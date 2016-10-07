library jaguar.generator.phases;

import 'dart:io';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:yaml/yaml.dart';

import 'api_annotation.dart';
import 'pre_processor/pre_processor_function_annotation_generator.dart';
import 'post_processor/post_processor_function_annotation_generator.dart';

String getProjectName() {
  File pubspec = new File('./pubspec.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['name'];
}

List<String> getApis() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['annotations'];
}

PhaseGroup phaseGroup() {
  String projectName = getProjectName();
  if (projectName == null) {
    throw "Could not find the project name";
  }
  List<String> apis = getApis();
  return new PhaseGroup.singleAction(
      new GeneratorBuilder(const [
        const ApiAnnotationGenerator(),
        const PreProcessorFunctionAnnotationGenerator(),
        const PostProcessorFunctionAnnotationGenerator()
      ]),
      new InputSet(projectName, apis));
}
