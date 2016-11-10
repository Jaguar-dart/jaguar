library jaguar.generator.parser.exception_handler;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'package:source_gen_help/import.dart';

class ExceptionHandlerInfo {
  final AnnotationElementWrap _handler;

  final DartTypeWrap _exception;

  String get handlerName => _handler.displayName;

  String get exceptionName => _exception.name;

  ExceptionHandlerInfo(ElementAnnotation aHandler, this._exception)
      : _handler = new AnnotationElementWrap(aHandler);

  String get instantiationString => ' new ' + _handler.instantiationString;
}

ExceptionHandlerInfo _parseExceptions(ElementAnnotation element) {
  element.computeConstantValue();

  if (element.constantValue.type.element is! ClassElement) {
    return null;
  }

  ClassElementWrap clazz =
      new ClassElementWrap(element.constantValue.type.element);

  const NamedElement kExceptionHandler =
      const NamedElementImpl.Make('ExceptionHandler', 'jaguar.src.annotations');
  InterfaceTypeWrap interface = clazz.getSubtypeOf(kExceptionHandler);
  if (interface is! InterfaceTypeWrap) {
    return null;
  }

  if (interface.typeArguments.length == 0) {
    return null; //TODO throw?
  }

  return new ExceptionHandlerInfo(element, interface.typeArguments[0]);
}

List<ExceptionHandlerInfo> collectExceptionHandlers(Element element) {
  return element.metadata
      .map((ElementAnnotation annot) => _parseExceptions(annot))
      .where((value) => value is ExceptionHandlerInfo)
      .toList();
}
