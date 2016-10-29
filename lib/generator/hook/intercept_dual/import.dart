library jaguar.generator.hook.intercept.dual;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:jaguar/generator/writer/import.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar/generator/parser/import.dart';

class ApiGenerator extends GeneratorForAnnotation<ant.Api> {
  const ApiGenerator();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, ant.Api api, BuildStep buildStep) async {
    ClassElement classElement = element;
    String className = classElement.name;

    Writer w = new Writer(className);

    final String prefix = api.url;

    List<InterceptorInfo> interceptors = parseInterceptor(element);

    List<RouteInfo> routes =
    collectAllRoutes(classElement, prefix, interceptors);

    w.addAllRoutes(routes);

    return w.toString();
  }
}
