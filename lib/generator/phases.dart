library jaguar.generator.phases;

import 'dart:io';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:yaml/yaml.dart';

import 'api_generator.dart';
import 'pre_interceptors/generator.dart';
import 'post_interceptors/generator.dart';

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

List<String> getPreInterceptor() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['pre_interceptors'] ?? <String>[];
}

List<String> getPostInterceptor() {
  File pubspec = new File('./jaguar.yaml');
  String content = pubspec.readAsStringSync();
  var doc = loadYaml(content);
  return doc['post_interceptors'] ?? <String>[];
}

Phase postInterceptorPhase(String projectName, List<String> postInterceptors) {
  return new Phase()
    ..addAction(
        new GeneratorBuilder(const [
          const PostInterceptorGenerator(),
        ]),
        new InputSet(projectName, postInterceptors));
}

Phase preInterceptorPhase(String projectName, List<String> preInterceptors) {
  return new Phase()
    ..addAction(
        new GeneratorBuilder(const [
          const PreInterceptorGenerator(),
        ]),
        new InputSet(projectName, preInterceptors));
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
    List<String> postInterceptors,
    List<String> preInterceptors,
    List<String> apis}) {
  PhaseGroup phaseGroup = new PhaseGroup();
  if (postInterceptors.isNotEmpty) {
    phaseGroup.addPhase(postInterceptorPhase(projectName, postInterceptors));
  }
  if (preInterceptors.isNotEmpty) {
    phaseGroup.addPhase(preInterceptorPhase(projectName, preInterceptors));
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
  List<String> postInterceptor = getPostInterceptor();
  List<String> preInterceptor = getPreInterceptor();
  return generatePhaseGroup(
      projectName: projectName,
      postInterceptors: postInterceptor,
      preInterceptors: preInterceptor,
      apis: apis);
}
