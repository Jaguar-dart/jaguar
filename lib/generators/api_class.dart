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

class GroupInformations {
  final String prefix;
  final String resourceName;

  GroupInformations(this.prefix, this.resourceName);
}

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

    await _groupRecursion(
        classElement, writer, "/${annotation.name}/${annotation.version}");
    return writer.generate();
  }

  Future<Null> _groupRecursion(ClassElement classElement, Writer writer,
      [String prefix = '',
      String resourceName = '',
      List<dynamic> parentPreparesRequest = const [],
      List<dynamic> parentPreparesResponse = const []]) async {
    classElement.methods.forEach((MethodElement methodElement) {
      Map<int, ElementAnnotation> routes = <int, ElementAnnotation>{};
      Map<int, ElementAnnotation> decodeJsonBodys = <int, ElementAnnotation>{};
      Map<int, ElementAnnotation> encodeResponseToJSon =
          <int, ElementAnnotation>{};
      methodElement.metadata
          .asMap()
          .forEach((int key, ElementAnnotation elementAnnotation) {
        if (matchAnnotation(Route, elementAnnotation)) {
          routes.putIfAbsent(key, () => elementAnnotation);
        } else if (matchAnnotation(DecodeBodyToJson, elementAnnotation)) {
          decodeJsonBodys.putIfAbsent(key, () => elementAnnotation);
        } else if (matchAnnotation(EncodeResponseToJson, elementAnnotation)) {
          encodeResponseToJSon.putIfAbsent(key, () => elementAnnotation);
        }
      });

      routes.forEach((int key, ElementAnnotation annotation) {
        Route route = instantiateAnnotation(annotation);
        List<dynamic> preparesRequest = <dynamic>[]
          ..addAll(parentPreparesRequest);
        List<dynamic> preparesResponse = <dynamic>[]
          ..addAll(parentPreparesResponse);
        for (int i = 0; i < methodElement.metadata.length; i++) {
          if (decodeJsonBodys.containsKey(i)) {
            DecodeBodyToJson decode = instantiateAnnotation(decodeJsonBodys[i]);
            preparesRequest
                .add(new DecodeEncodeToJsonInformations(decode.encoding));
          } else if (encodeResponseToJSon.containsKey(i)) {
            EncodeResponseToJson encode =
                instantiateAnnotation(encodeResponseToJSon[i]);
            preparesResponse
                .add(new DecodeEncodeToJsonInformations(encode.encoding));
          }
        }
        writer.addRoute(new RouteInformationsGenerator(
            "$prefix/${route.path}",
            route.methods,
            "$resourceName${resourceName.isEmpty ? '' : '.'}${methodElement.displayName}",
            methodElement.returnType.displayName,
            methodElement.parameters,
            preparesRequest: preparesRequest,
            preparesResponse: preparesResponse));
      });
    });

    for (int i = 0; i < classElement.fields.length; i++) {
      FieldElement fieldElement = classElement.fields[i];
      Map<int, FieldElement> groupFields = <int, FieldElement>{};
      Map<int, ElementAnnotation> groups = <int, ElementAnnotation>{};
      List<dynamic> prepareRequest = <dynamic>[]..addAll(parentPreparesRequest);
      List<dynamic> prepareResponse = <dynamic>[]
        ..addAll(parentPreparesResponse);
      fieldElement.metadata
          .asMap()
          .forEach((int key, ElementAnnotation elementAnnotation) {
        if (matchAnnotation(Group, elementAnnotation)) {
          groups.putIfAbsent(key, () => elementAnnotation);
          groupFields.putIfAbsent(key, () => fieldElement);
        } else if (matchAnnotation(DecodeBodyToJson, elementAnnotation)) {
          DecodeBodyToJson decodeBodyToJson =
              instantiateAnnotation(elementAnnotation);
          prepareRequest.add(
              new DecodeEncodeToJsonInformations(decodeBodyToJson.encoding));
        } else if (matchAnnotation(EncodeResponseToJson, elementAnnotation)) {
          EncodeResponseToJson decodeBodyToJson =
              instantiateAnnotation(elementAnnotation);
          prepareResponse.add(
              new DecodeEncodeToJsonInformations(decodeBodyToJson.encoding));
        }
      });

      for (int i = 0; i < groupFields.length; i++) {
        Group group = instantiateAnnotation(groups[i]);
        for (int j = 0; j < fieldElement.metadata.length; j++) {}
        await _groupRecursion(
            groupFields[i].type.element,
            writer,
            "$prefix/${group.path}",
            groupFields[i].displayName,
            prepareRequest,
            prepareResponse);
      }

      // List<FieldElement> apiResourcesFields = <FieldElement>[];
      // List<ElementAnnotation> apiResources =
      //     fieldElement.metadata.where((ElementAnnotation elementAnnotation) {
      //   bool match = matchAnnotation(Group, elementAnnotation);
      //   if (match) {
      //     apiResourcesFields.add(fieldElement);
      //     return true;
      //   }
      //   return false;
      // }).toList();
      //
      // for (int i = 0; i < apiResources.length; i++) {
      //   Group apiResource = instantiateAnnotation(apiResources[i]);
      //   await _apiResourceRecursion(apiResourcesFields[i].type.element, writer,
      //       "$prefix/${apiResource.path}", apiResourcesFields[i].displayName);
      // }

    }
  }

  String toString() => 'ApiClass';
}

// class ApiClassGenerator extends Generator {
//   Future<String> generator(Element element, BuildStep buildStep) async {
//     return "hello";
//   }
// }
