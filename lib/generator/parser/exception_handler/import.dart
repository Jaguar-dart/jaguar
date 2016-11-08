library jaguar.generator.parser.exception_handler;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'package:source_gen_help/import.dart';

class ExceptionHandlerInfo {
  final AnnotationElementWrap _handler;

  final DartTypeWrap _exception;

  String get handlerName => _handler.displayName;

  String get exceptionName => _exception.name;

  ExceptionHandlerInfo(ElementAnnotation aHandler, DartType aException)
      : _handler = new AnnotationElementWrap(aHandler),
        _exception = new DartTypeWrap(aException);

  String get instantiationString => ' new ' + _handler.instantiationString;
}

List<ExceptionHandlerInfo> _parseExceptions(ElementAnnotation element) {
  element.computeConstantValue();
  return element.constantValue.type.element.metadata
      .where((ElementAnnotation annot) {
    final typeWrapped = new DartTypeWrap(annot.constantValue.type);
    return typeWrapped.compare('ExceptionHandler', 'jaguar.src.annotations');
  }).map((ElementAnnotation annot) {
    DartType exception =
        annot.constantValue.getField('exception').toTypeValue();
    return new ExceptionHandlerInfo(element, exception);
  }).toList();
}

List<ExceptionHandlerInfo> collectExceptionHandlers(Element element) {
  return element.metadata.fold(<ExceptionHandlerInfo>[],
      (List<ExceptionHandlerInfo> list, ElementAnnotation annot) {
    return _parseExceptions(annot);
  });
}
