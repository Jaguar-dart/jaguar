library jaguar.generator.phases;

import 'dart:io';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:yaml/yaml.dart';

import 'api_generator.dart';
import 'pre_interceptors/pre_interceptors_generator.dart';
import 'post_interceptors/post_interceptors_generator.dart';

String getProjectName() {
  File pubspec = new File('./pubspec.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['name'];
}

List<String> getAnnotations() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['apis'];
}

List<String> getPreProcessor() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['pre_processors'] == null ? <String>[] : doc['pre_processors'];
}

List<String> getPostProcessor() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['post_processors'] == null ? <String>[] : doc['post_processors'];
}

Phase postProcessorPhase(String projectName, List<String> postProcessors) {
  return new Phase()
    ..addAction(
        new GeneratorBuilder(const [
          const PostInterceptorGenerator(),
        ]),
        new InputSet(projectName, postProcessors));
}

Phase preProcessorPhase(String projectName, List<String> preProcessors) {
  return new Phase()
    ..addAction(
        new GeneratorBuilder(const [
          const PreInterceptorGenerator(),
        ]),
        new InputSet(projectName, preProcessors));
}

Phase apisPhase(String projectName, List<String> apis) {
  return new Phase()
    ..addAction(
        new GeneratorBuilder(const [
          const ApiGenerator(),
        ]),
        new InputSet(projectName, apis));
}

PhaseGroup generatePhaseGroup(
    {String projectName,
    List<String> postProcessors,
    List<String> preProcessors,
    List<String> apis}) {
  PhaseGroup phaseGroup = new PhaseGroup();
  if (postProcessors.isNotEmpty) {
    phaseGroup.addPhase(postProcessorPhase(projectName, postProcessors));
  }
  if (preProcessors.isNotEmpty) {
    phaseGroup.addPhase(preProcessorPhase(projectName, preProcessors));
  }
  phaseGroup.addPhase(apisPhase(projectName, apis));
  return phaseGroup;
}

PhaseGroup phaseGroup() {
  String projectName = getProjectName();
  if (projectName == null) {
    throw "Could not find the project name";
  }
  List<String> apis = getAnnotations();
  if (apis == null) {
    throw "You need to provide one or more api file";
  }
  List<String> postProcessor = getPostProcessor();
  List<String> preProcessor = getPreProcessor();
  return generatePhaseGroup(
      projectName: projectName,
      postProcessors: postProcessor,
      preProcessors: preProcessor,
      apis: apis);
}
