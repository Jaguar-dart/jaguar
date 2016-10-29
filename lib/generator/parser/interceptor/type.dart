part of jaguar.generator.parser.interceptor;

class InterceptorType {
  final DartType type;

  String get libraryName => type.element.library.displayName;

  String get displayName => type.displayName;

  InterceptorType.FromDartType(this.type);

  String get fullname => '$libraryName.$displayName';

  bool hasType(InterceptorAnnotationInstance other) {
    if(libraryName != other.libraryName) {
      return false;
    }

    if(displayName != other.displayName) {
      return false;
    }

    return true;
  }
}

class InterceptorAnnotationInstance {
  final ElementAnnotation element;

  String _id;

  String get id => _id;

  String get libraryName => element.constantValue.type.element.library.displayName;

  String get displayName => element.constantValue.type.displayName;

  InterceptorAnnotationInstance(this.element) {
    _id = element.constantValue.getField('(super)')?.getField('id')?.toStringValue();
  }

  String get instantiationString {
    String lRet = (element as ElementAnnotationImpl).annotationAst.toSource();
    lRet = lRet.substring(1);
    return 'new ' + lRet;
  }
}
