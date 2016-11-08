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

class InterceptorClassInfo implements InterceptorInfo {
  ElementAnnotation elememt;

  ant.InterceptorClass _defined;

  InterceptorClassDef dual;

  InterceptorAnnotationInstance interceptor;

  @override
  bool get writesResponse => _defined.writesResponse;

  @override
  DartType get result => dual.returnType;

  DartType get returnsFutureFlattened => dual.returnsFutureFlattened;

  String get _genBaseName => interceptor.name + (id ?? '');

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
  InterceptorClassInfo(this.elememt, this._defined) {
    final ClassElement clazz =
        elememt.element.getAncestor((Element el) => el is ClassElement);
    interceptor = new InterceptorAnnotationInstance(elememt);
    dual = new InterceptorClassDef(clazz);
  }

  String toString() {
    return '$_genBaseName{$dual}';
  }

  List<Input> get inputs {
    List<Input> ret = <Input>[];

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
    sb.write(interceptor.name + " ");
    sb.write(genInstanceName + " = ");
    sb.write(interceptor.instantiationString);
    sb.writeln(";");
    return sb.toString();
  }

  bool get shouldKeepQueryParam {
    if (dual.pre != null && dual.pre.shouldKeepQueryParam) {
      return true;
    }

    if (dual.post != null && dual.post.shouldKeepQueryParam) {
      return true;
    }

    return false;
  }

  bool get canCreateState {
    MethodElement meth = dual.clazz.getMethod('createState');

    if (meth == null) {
      return false;
    }

    MethodElementWrap methWrapped = new MethodElementWrap(meth);

    if (!methWrapped.isStatic) {
      return false;
    }

    if (methWrapped.requiredParameters.length != 0) {
      //TODO warn? throw error?
      return false;
    }

    if (methWrapped.returnType.isVoid) {
      //TODO warn? throw error?
      return false;
    }

    return true;
  }

  bool get needsState {
    //TODO right now, we don't allow positional parameters
    if (dual.constructor.areOptionalParamsPositional) {
      return false;
    }

    return dual.constructor.findOptionalParamByName('state') != null;
  }
}
