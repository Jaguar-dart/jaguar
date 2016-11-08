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

  final Map<String, DartTypeWrap> params = {};

  void _populateParams() {
    DartObject object = _constVal.getField('(super)')?.getField('params');
    if (object is! DartObject) {
      return;
    }

    Map map = object.toMapValue();

    if (map is! Map) {
      return;
    }

    map.forEach((DartObject key, DartObject val) {
      final String name = key.toSymbolValue();
      if (name == 'state' || name == 'params') {
        throw new Exception(
            'Cannot provide state and params param to interceptor!');
      }
      params[key.toSymbolValue()] = new DartTypeWrap(val.toTypeValue());
    });
  }

  InterceptorAnnotationInstance(this.element) {
    _constVal = element.computeConstantValue();
    _type = new DartTypeWrap(_constVal.type);
    _id = _constVal.getField('(super)')?.getField('id')?.toStringValue();
    _populateParams();
  }

  String get instantiationString {
    String lRet = (element as ElementAnnotationImpl).annotationAst.toSource();
    lRet = lRet.substring(1);
    return 'new ' + lRet;
  }
}
