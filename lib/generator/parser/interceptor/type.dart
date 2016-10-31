part of jaguar.generator.parser.interceptor;

class InterceptorAnnotationInstance {
  final ElementAnnotation element;

  DartObject _constVal;

  DartTypeWrap _type;

  DartTypeWrap get type => _type;

  String _id;

  String get id => _id;

  String get libraryName => _type.libraryName;

  String get name => _type.name;

  InterceptorAnnotationInstance(this.element) {
    _constVal = element.computeConstantValue();
    _type = new DartTypeWrap(_constVal.type);
    _id = _constVal.getField('(super)')?.getField('id')?.toStringValue();
  }

  String get instantiationString {
    String lRet = (element as ElementAnnotationImpl).annotationAst.toSource();
    lRet = lRet.substring(1);
    return 'new ' + lRet;
  }
}
