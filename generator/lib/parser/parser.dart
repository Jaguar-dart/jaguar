library jaguar.generator.parser.route;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';

import '../common/constants.dart';

import '../models/models.dart';

class _Parser {
  final ClassElement controller;

  String prefix;

  final routes = <RouteModel>[];

  final groups = <GroupModel>[];

  _Parser(this.controller);

  _Parser parse() {
    DartObject annot = isGenController.firstAnnotationOf(controller);
    prefix = annot.getField("path")?.toStringValue();

    _collectRoutes();

    _collectIncludes();

    return this;
  }

  void _collectRoutes() {
    for (MethodElement method in controller.methods) {
      method.metadata.forEach((annot) {
        final annotObj = annot.computeConstantValue();

        if (!isHttpMethod.isAssignableFromType(annotObj.type)) return;

        final route = RouteModel(
          method.displayName,
          method.returnType.toString(),
          annot.toSource().substring(1),
          path: annotObj.getField("path")?.toStringValue(),
          methods: annotObj
              .getField("methods")
              ?.toListValue()
              ?.map((v) => v.toStringValue())
              ?.toList()
              ?.cast<String>(),
          pathRegEx: annotObj.getField("pathRegEx")?.toMapValue()?.map((k, v) =>
              MapEntry<String, String>(k.toStringValue(), v.toStringValue())),
          statusCode: annotObj.getField("statusCode")?.toIntValue(),
          mimeType: annotObj.getField("mimeType")?.toStringValue(),
          charset: annotObj.getField("charset")?.toStringValue(),
          // TODO responseProcessor
        );
        routes.add(route);
      });
    }
  }

  void _collectIncludes() {
    for (FieldElement field in controller.fields) {
      isIncludeController.annotationsOf(field).map((annot) {
        return GroupModel(field.displayName, field.type.toString(),
            path: annot.getField("path")?.toStringValue());
      }).forEach(groups.add);
      // TODO
    }
  }

  ControllerModel make() {
    return ControllerModel(controller.displayName)
      ..routes.addAll(routes)
      ..groups.addAll(groups);
  }
}

ControllerModel parse(ClassElement controller) =>
    _Parser(controller).parse().make();
