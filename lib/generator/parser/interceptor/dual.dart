part of jaguar.generator.parser.interceptor;

/// Holds information about pre and post interceptors in interceptor class
class InterceptorDualDef {
  /// The class element of the interceptor
  ClassElement clazz;

  /// Pre interceptor info
  InterceptorFuncDef pre;

  /// Post interceptor info
  InterceptorFuncDef post;

  DartType get returnType => pre?.returnType;

  DartType get returnsFutureFlattened => pre?.returnsFutureFlattened;

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

  ant.DefineInterceptDual _defined;

  InterceptorDualDef dual;

  InterceptorAnnotationInstance interceptor;

  @override
  bool get writesResponse => _defined.writesResponse;

  @override
  DartType get result => dual.returnType;

  DartType get returnsFutureFlattened => dual.returnsFutureFlattened;

  String get _genBaseName => interceptor.displayName + (id ?? '');

  String get genInstanceName => 'i$_genBaseName';

  String get genReturnVarName => 'r$_genBaseName';

  String get id => interceptor.id;

  bool matchesResultType(DartType type) {
    if (!result.isDartAsyncFuture) {
      return type.isSupertypeOf(result);
    } else {
      DartType flattenedType =
          result.flattenFutures(elememt.context.typeSystem);
      return type.isSupertypeOf(flattenedType);
    }
  }

  ///Create dual interceptor info for given interceptor usage
  DualInterceptorInfo(this.elememt, this._defined) {
    final ClassElement clazz =
        elememt.element.getAncestor((Element el) => el is ClassElement);
    interceptor = new InterceptorAnnotationInstance(elememt);
    dual = new InterceptorDualDef(clazz);
  }

  String toString() {
    return '$_genBaseName{$dual}';
  }

  List<InputInfo> get inputs {
    List<InputInfo> ret = <InputInfo>[];

    if (dual.pre != null) {
      ret.addAll(dual.pre.inputs);
    }

    if (dual.post != null) {
      ret.addAll(dual.post.inputs);
    }

    return ret;
  }

  String get instantiationString {
    StringBuffer sb = new StringBuffer();
    sb.write(interceptor.displayName + " ");
    sb.write(genInstanceName + " = ");
    sb.write(interceptor.instantiationString);
    sb.writeln(";");
    return sb.toString();
  }
}
