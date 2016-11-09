library jaguar.generator.hook.route_group;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:jaguar/generator/writer/import.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar/generator/parser/import.dart';

class RouteGroupGenerator extends GeneratorForAnnotation<ant.RouteGroup> {
  const RouteGroupGenerator();

  /// Generator
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ant.RouteGroup routeGroup, BuildStep buildStep) async {
    if (element is! ClassElement) {
      throw new Exception("Api annotation can only be defined on a class.");
    }

    ClassElement classElement = element;
    String className = classElement.name;

    print("Generating for RouteGroup class $className ...");

    Writer writer = new Writer(className, forGroupRoute: true);

    final String prefix = routeGroup.path;

    List<InterceptorInfo> interceptors = parseInterceptor(element);

    List<ExceptionHandlerInfo> exceptions = collectExceptionHandlers(element);

    List<RouteInfo> routes =
        collectRoutes(classElement, prefix, interceptors, exceptions, []);

    writer.addGroups(collectGroups(classElement));

    writer.addAllRoutes(routes);

    return writer.toString();
  }
}
