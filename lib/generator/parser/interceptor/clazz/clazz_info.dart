part of jaguar.generator.parser.interceptor;

class InterceptorClassInfo implements InterceptorInfo {
  ElementAnnotation element;

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
          result.flattenFutures(element.context.typeSystem);
      return type.isSupertypeOf(flattenedType);
    }
  }

  ///Create dual interceptor info for given interceptor usage
  InterceptorClassInfo(this.element, this._defined) {
    final ClassElement clazz =
        element.element.getAncestor((Element el) => el is ClassElement);
    interceptor = new InterceptorAnnotationInstance(element);
    dual = new InterceptorClassDef(clazz);

    _validate();
  }

  void _validate() {
    interceptor.params.forEach((String key, DartTypeWrap type) {
      ParameterElement param = dual.constructor.findOptionalParamByName(key);
      if (param == null) {
        throw new Exception('Unknown interceptor param $key!');
      }

      if (!type.isAssignableTo(new DartTypeWrap(param.type))) {
        throw new Exception(
            'Cannot assign ${type.displayName} to ${param.type.displayName}!');
      }
    });
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
