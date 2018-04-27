part of jaguar.generator.parser.route;

InterceptorCreatorFunc _parseInterceptorCreator(DartObjectImpl obj) {
  if (obj.toSymbolValue() != null) {
    return new InterceptorCreatorFunc(obj.toSymbolValue(), true, false);
  }
  if (obj.type is! FunctionType)
    throw new Exception('Interceptor creator much be a Function or a Symbol!');
  return new InterceptorCreatorFunc(
      obj.type.element.name, false, obj.type.element is MethodElement);
}

/// Detects interceptors on a given method or class
List<InterceptorCreatorFunc> detectWrappers(
    ClassElement upper, Element element) {
  final ret = <InterceptorCreatorFunc>[];

  for (ElementAnnotation annot in element.metadata) {
    final DartObject v = annot.computeConstantValue();
    if (isWrap.isExactlyType(v.type)) {
      v
          .getField('interceptors')
          .toListValue()
          .map((o) => o as DartObjectImpl)
          .map(_parseInterceptorCreator)
          .forEach(ret.add);
    } else if (isWrapOne.isExactlyType(v.type)) {
      DartObjectImpl f = v.getField('interceptor');
      ret.add(_parseInterceptorCreator(f));
    }
  }

  return ret;
}
