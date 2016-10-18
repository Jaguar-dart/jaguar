part of  jaguar.generator.parser.interceptor;

/// Holds information about pre and post interceptors in interceptor class
class InterceptorDualDef {
  /// The class element of the interceptor
  ClassElement clazz;

  /// Pre interceptor info
  InterceptorFuncDef pre;

  /// Post interceptor info
  InterceptorFuncDef post;

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

  Type interceptor;

  Type returns;

  DartType returnsD;

  bool matchesReturnType(DartType type) {
    if(!returnsD.isDartAsyncFuture) {
      return type.isSupertypeOf(returnsD);
    } else {
      DartType flattenedType = returnsD.flattenFutures(elememt.context.typeSystem);
      return type.isSupertypeOf(flattenedType);
    }
  }

  ///Create dual interceptor info for given interceptor usage
  DualInterceptorInfo(this.elememt) {
    final ClassElement clazz =
    elememt.element.getAncestor((Element el) => el is ClassElement);
    interceptor = instantiateAnnotation(elememt).runtimeType;
    dual = new InterceptorDualDef(clazz);
    returns = getClassInterceptDual(clazz).returns;
    returnsD = dual.pre.method.returnType;
  }

  String toString() {
    return '{$dual}';
  }

  String makeParams() {
    String lRet = (elememt as ElementAnnotationImpl).annotationAst.toSource();
    lRet = lRet.substring(1);
    return lRet;
  }
}