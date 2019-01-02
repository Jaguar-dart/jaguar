library jaguar.generator.parser.route;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';

import '../common/constants.dart';

import '../models/models.dart';

class _Parser {
  final ClassElement controller;

  String prefix;

  final routes = <RouteModel>[];

  _Parser(this.controller);

  _Parser parse() {
    DartObject annot = isGenController.firstAnnotationOf(controller);
    prefix = annot.getField("path")?.toStringValue();

    _collectRoutes();

    // TODO collect includes

    return this;
  }

  void _collectRoutes() {
    for (MethodElement method in controller.methods) {
      List<DartObject> annots = isHttpMethod.annotationsOf(method).toList();

      if (annots.isEmpty) continue;

      annots.map((DartObject annot) {
        DartObject respProc = annot.getField("responseProcessor");
        print(respProc.runtimeType);
        return RouteModel(
          method.displayName,
          method.returnType.toString(),
          path: annot.getField("path")?.toStringValue(),
          methods: annot
              .getField("methods")
              ?.toListValue()
              ?.map((v) => v.toStringValue())
              ?.toList()
              ?.cast<String>(),
          pathRegEx: annot.getField("pathRegEx")?.toMapValue()?.map((k, v) =>
              MapEntry<String, String>(k.toStringValue(), v.toStringValue())),
          statusCode: annot.getField("statusCode")?.toIntValue(),
          mimeType: annot.getField("mimeType")?.toStringValue(),
          charset: annot.getField("charset")?.toStringValue(),
          // TODO responseProcessor
        );
      }).forEach(routes.add);
    }
  }

  void _collectIncludes() {
    for (FieldElement field in controller.fields) {
      // TODO
    }
  }

  ControllerModel make() {
    return ControllerModel(controller.displayName)..routes.addAll(routes);
  }
}

ControllerModel parse(ClassElement controller) =>
    _Parser(controller).parse().make();
