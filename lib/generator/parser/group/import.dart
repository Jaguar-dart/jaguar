library jaguar.generator.parser.group;

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;

import 'package:jaguar/generator/parser/route/import.dart';
import 'package:jaguar/generator/parser/interceptor/import.dart';
import 'package:jaguar/generator/parser/exception_handler/import.dart';

import 'package:jaguar/generator/internal/element/import.dart';

ant.Group parseGroup(Element element) {
  return element.metadata.map((ElementAnnotation annot) {
    annot.computeConstantValue();
    try {
      return instantiateAnnotation(annot);
    } catch (_) {
      return null;
    }
  }).firstWhere((dynamic instance) => instance is ant.Group,
      orElse: () => null);
}

List<RouteInfo> collectAllRoutes(
    ClassElement classElement,
    String prefix,
    List<InterceptorInfo> interceptorsParent,
    List<ExceptionHandlerInfo> exceptionsParent,
    List<String> groupNames) {
  List<RouteInfo> routes = collectRoutes(
      classElement, prefix, interceptorsParent, exceptionsParent, groupNames);

  classElement.fields
      .map((FieldElement field) {
        ant.Group group = parseGroup(field);

        if (group == null) {
          return null;
        }

        return collectAllRoutes(
            field.type.element,
            "$prefix${group.path}",
            interceptorsParent,
            exceptionsParent,
            groupNames.toList()..add(field.name));
      })
      .where((List<RouteInfo> routes) => routes != null)
      .forEach((List<RouteInfo> val) => routes.addAll(val));

  return routes;
}

class GroupInfo {
  final ant.Group group;

  final DartTypeWrap type;

  final String name;

  GroupInfo(this.group, this.type, this.name);
}

List<GroupInfo> collectGroups(ClassElement classElement) {
  return classElement.fields
      .map((FieldElement field) {
        ant.Group group = parseGroup(field);

        if (group == null) {
          return null;
        }

        return new GroupInfo(group, new DartTypeWrap(field.type), field.name);
      })
      .where((GroupInfo group) => group is GroupInfo)
      .toList();
}
