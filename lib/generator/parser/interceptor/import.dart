library jaguar.generator.parser.interceptor;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/dart/element/element.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/generator/parser/import.dart';

part 'func.dart';
part 'dual.dart';

abstract class InterceptorInfo {
  DartType get returns;
}

bool isAnnotationInterceptDual(ElementAnnotation annot) {
  final ClassElement clazz =
      annot.element.getAncestor((Element el) => el is ClassElement);

  if (clazz == null) {
    return false;
  }

  return isClassInterceptDual(clazz);
}

bool isClassInterceptDual(ClassElement clazz) {
  clazz.metadata
      .forEach((ElementAnnotation annot) => annot.computeConstantValue());
  var matchingAnnotations = clazz.metadata
      .map((ElementAnnotation annot) {
        try {
          return instantiateAnnotation(annot);
        } catch (_) {
          //TODO check what exception and decide accordingly
          return null;
        }
      })
      .where((dynamic instance) => instance is ant.InterceptDual)
      .toList();

  if (matchingAnnotations.isEmpty) {
    return false;
  } else if (matchingAnnotations.length > 1) {
    throw 'Cannot define InterceptDual more than once';
  }

  return true;
}

ant.InterceptDual getClassInterceptDual(ClassElement clazz) {
  clazz.metadata
      .forEach((ElementAnnotation annot) => annot.computeConstantValue());
  var matchingAnnotations = clazz.metadata
      .map((ElementAnnotation annot) {
        try {
          return instantiateAnnotation(annot);
        } catch (_) {
          //TODO check what exception and decide accordingly
          return null;
        }
      })
      .where((dynamic instance) => instance is ant.InterceptDual)
      .toList();

  if (matchingAnnotations.isEmpty) {
    return null;
  } else if (matchingAnnotations.length > 1) {
    throw 'Cannot define InterceptDual more than once';
  }

  return matchingAnnotations[0];
}

///Parse interceptors for a given method or class element
List<InterceptorInfo> parseInterceptor(Element element) {
  return element.metadata
      .map((ElementAnnotation annot) {
        if (!isAnnotationInterceptDual(annot)) {
          return null;
        }

        return new DualInterceptorInfo(annot);
      })
      .where((dynamic val) => val != null)
      .toList();
}
