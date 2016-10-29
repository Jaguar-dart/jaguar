part of  jaguar.generator.parser.interceptor;

/// Holds information about pre and post interceptors in interceptor class
class InterceptorDualDef {
  /// The class element of the interceptor
  ClassElement clazz;

  /// Pre interceptor info
  InterceptorFuncDef pre;

  /// Post interceptor info
  InterceptorFuncDef post;

  DartType get returnType => pre?.returnType;

  /// Default constructor. Constructs [InterceptorDualDef] for a given class
  InterceptorDualDef(this.clazz) {
    /// Find pre and post interceptors in class
    clazz.methods.forEach((MethodElement method) {
      if (method.name == 'pre') {
        pre = new InterceptorFuncDef(method);
      } else if (method.name == 'post') {
        post = new InterceptorFuncDef(method);
      }
    });
  }

  /// Debug printer
  String toString() {
    return "$pre $post";
  }
}

class DualInterceptorInfo implements InterceptorInfo {
  ElementAnnotation elememt;

  InterceptorDualDef dual;

  InterceptorAnnotationInstance interceptor;

  DartType get returns => dual.returnType;

  String get _genBaseName => interceptor.displayName + (id??'');

  String get genInstanceName => 'i$_genBaseName';

  String get genReturnVarName => 'r$_genBaseName';

  String get id => interceptor.id;

  bool matchesReturnType(DartType type) {
    if(!returns.isDartAsyncFuture) {
      return type.isSupertypeOf(returns);
    } else {
      DartType flattenedType = returns.flattenFutures(elememt.context.typeSystem);
      return type.isSupertypeOf(flattenedType);
    }
  }

  ///Create dual interceptor info for given interceptor usage
  DualInterceptorInfo(this.elememt) {
    final ClassElement clazz =
    elememt.element.getAncestor((Element el) => el is ClassElement);
    interceptor = new InterceptorAnnotationInstance(elememt);
    dual = new InterceptorDualDef(clazz);
  }

  String toString() {
    return '$_genBaseName{$dual}';
  }
}
