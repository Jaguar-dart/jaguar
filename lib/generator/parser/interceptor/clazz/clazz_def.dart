part of jaguar.generator.parser.interceptor;

/// Holds information about pre and post interceptors in interceptor class
class InterceptorClassDef {
  /// The class element of the interceptor
  ClassElement clazz;

  /// Pre interceptor info
  InterceptorFuncDef pre;

  /// Post interceptor info
  InterceptorFuncDef post;

  DartType get returnType => pre?.returnType;

  DartType get returnsFutureFlattened => pre?.returnsFutureFlattened;

  /// Default constructor. Constructs [InterceptorClassDef] for a given class
  InterceptorClassDef(this.clazz) {
    /// Find pre and post interceptors in class
    clazz.methods.forEach((MethodElement method) {
      if (method.name == 'pre') {
        pre = new InterceptorFuncDef(method);
      } else if (method.name == 'post') {
        post = new InterceptorFuncDef(method);
      }
    });
  }

  //TODO check in unnamedConstructor is null?
  ConstructorElementWrap get constructor =>
      new ConstructorElementWrap(clazz.unnamedConstructor);

  /// Debug printer
  String toString() {
    return "$pre $post";
  }
}

class InterceptorParamInfo {}
