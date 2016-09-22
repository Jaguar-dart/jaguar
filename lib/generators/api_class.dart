library source_gen_experimentation.generators.api_class;

import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/annotation.dart';
import 'package:source_gen/src/utils.dart';
import 'package:jaguar/src/annotations.dart';

import 'writer.dart';
import 'route.dart';

class ApiClassAnnotationGenerator extends GeneratorForAnnotation<Api> {
  const ApiClassAnnotationGenerator();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, Api annotation, BuildStep buildStep) async {
    if (element is! ClassElement) {
      var friendlyName = friendlyNameForElement(element);
      throw new InvalidGenerationSourceError(
          'Generator cannot target `$friendlyName`.',
          todo: 'Remove the Group annotation from `$friendlyName`.');
    }
    ClassElement classElement = element;
    String className = classElement.name;

    StringBuffer sb = new StringBuffer();
    sb.writeln("//\t$className ${annotation.name} ${annotation.version}");
    Writer writer = new Writer(className);

    await _apiResourceRecursion(
        classElement, writer, "/${annotation.name}/${annotation.version}");
    return writer.generate();
  }

  Future<Null> _apiResourceRecursion(ClassElement classElement, Writer writer,
      [String prefix = '', String resourceName = '']) async {
    classElement.methods.forEach((MethodElement methodElement) {
      List<ElementAnnotation> apiMethods = methodElement.metadata
          .where((ElementAnnotation elementAnnotation) =>
              matchAnnotation(Route, elementAnnotation))
          .toList();

      apiMethods.forEach((ElementAnnotation elementAnnotation) {
        Route apiMethod = instantiateAnnotation(elementAnnotation);
        writer.addRoute(new RouteInformationsGenrator(
            "$prefix/${apiMethod.path}",
            apiMethod.methods,
            "$resourceName${resourceName.isEmpty ? '' : '.'}${methodElement.displayName}"));
        // sb.writeln(
        //     "//\t$prefix/${apiMethod.path} ${apiMethod.methods} $resourceName${resourceName.isEmpty ? '' : '.'}${methodElement.displayName}(HttpRequest request);");
      });
    });

    for (int i = 0; i < classElement.fields.length; i++) {
      FieldElement fieldElement = classElement.fields[i];
      List<FieldElement> apiResourcesFields = <FieldElement>[];
      List<ElementAnnotation> apiResources =
          fieldElement.metadata.where((ElementAnnotation elementAnnotation) {
        bool match = matchAnnotation(Group, elementAnnotation);
        if (match) {
          apiResourcesFields.add(fieldElement);
          return true;
        }
        return false;
      }).toList();

      for (int i = 0; i < apiResources.length; i++) {
        Group apiResource = instantiateAnnotation(apiResources[i]);
        await _apiResourceRecursion(apiResourcesFields[i].type.element, writer,
            "$prefix/${apiResource.path}", apiResourcesFields[i].displayName);
      }
    }
  }

  String toString() => 'ApiClass';
}

// class ApiClassGenerator extends Generator {
//   Future<String> generator(Element element, BuildStep buildStep) async {
//     return "hello";
//   }
// }
