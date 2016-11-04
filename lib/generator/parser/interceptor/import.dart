library jaguar.generator.parser.interceptor;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/generator/internal/element/import.dart';

import 'package:jaguar/generator/parser/import.dart';

part 'func.dart';
part 'dual.dart';
part 'type.dart';

abstract class InterceptorInfo {
  DartType get result;

  List<Input> get inputs;

  bool get writesResponse;
}

ant.InterceptorClass isAnnotationInterceptDual(ElementAnnotation annot) {
  final ClassElement clazz =
      annot.element.getAncestor((Element el) => el is ClassElement);

  if (clazz == null) {
    return null;
  }

  return isClassInterceptDual(clazz);
}

ant.InterceptorClass isClassInterceptDual(ClassElement clazz) {
  clazz.metadata
      .forEach((ElementAnnotation annot) => annot.computeConstantValue());
  List match = clazz.metadata
      .map((ElementAnnotation annot) {
        annot.computeConstantValue();
        try {
          return instantiateAnnotation(annot);
        } catch (_) {
          return null;
        }
      })
      .where((dynamic instance) => instance is ant.InterceptorClass)
      .toList();

  if (match.isEmpty) {
    return null;
  } else if (match.length > 1) {
    throw 'Cannot define InterceptDual more than once';
  }

  return match.single;
}

///Parse interceptors for a given method or class element
List<InterceptorInfo> parseInterceptor(Element element) {
  return element.metadata
      .map((ElementAnnotation annot) {
        ant.InterceptorClass dual = isAnnotationInterceptDual(annot);
        if (dual == null) {
          return null;
        }

        return new InterceptorClassInfo(annot, dual);
      })
      .where((dynamic val) => val != null)
      .toList();
}
