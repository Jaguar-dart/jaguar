part of jaguar.generator.info;

class InputInfo {
  final Type resultFrom;

  InputInfo(this.resultFrom);

  InputInfo.FromAnnot(ant.Input inp) : resultFrom = inp.resultFrom;

  String toString() {
    return '$resultFrom';
  }
}

class InterceptorFuncDef {
  MethodElement method;

  List<InputInfo> inputs = <InputInfo>[];

  InterceptorFuncDef(this.method) {
    method.metadata
        .forEach((ElementAnnotation annot) => annot.computeConstantValue());
    method.metadata
        .map((ElementAnnotation annot) => instantiateAnnotation(annot))
        .where((dynamic instance) => instance is ant.Input)
        .forEach((ant.Input inp) => inputs.add(new InputInfo.FromAnnot(inp)));
  }

  String toString() {
    String lRet = "(" + inputs.map((InputInfo inp) => '$inp}').join(',') + ')';
    return lRet;
  }
}

class InterceptorDualDef {
  ClassElement clazz;

  InterceptorFuncDef pre;

  InterceptorFuncDef post;

  InterceptorDualDef(this.clazz) {
    clazz.methods.forEach((MethodElement method) {
      if (method.name == 'pre') {
        pre = new InterceptorFuncDef(method);
      } else if (method.name == 'post') {
        post = new InterceptorFuncDef(method);
      }
    });
  }

  String toString() {
    return "$pre $post";
  }
}

abstract class InterceptorInfo {
  Type get returns;
}

class InterceptorFuncInfo implements InterceptorInfo {
  InterceptorFuncDef definition;

  bool isPost;

  Type returns;

  InterceptorFuncInfo(this.definition, {this.isPost: false});
}

class DualInterceptorInfo implements InterceptorInfo {
  ElementAnnotation elememt;

  InterceptorDualDef dual;

  Type interceptor;

  Type returns;

  DartType returnsD;

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
    final ClassElement clazz =
    elememt.element.getAncestor((Element el) => el is ClassElement);
    print(clazz.fields);

    final obj = instantiateAnnotation(elememt);

    InstanceMirror instmir = reflect(obj);

    print(instmir.getField(new Symbol('dbName')));
  }
}

bool isAnnotationInterceptDual(ElementAnnotation annot) {
  final ClassElement clazz =
      annot.element.getAncestor((Element el) => el is ClassElement);

  if (clazz == null) {
    return false;
  }

  return isClassInterceptDual(clazz);
}

bool isClassInterceptDual(ClassElement clazz) {
  clazz.metadata
      .forEach((ElementAnnotation annot) => annot.computeConstantValue());
  var matchingAnnotations = clazz.metadata
      .map((ElementAnnotation annot) => instantiateAnnotation(annot))
      .where((dynamic instance) => instance is ant.InterceptDual)
      .toList();

  if (matchingAnnotations.isEmpty) {
    return false;
  } else if (matchingAnnotations.length > 1) {
    throw 'Cannot define InterceptDual more than once';
  }

  return true;
}

ant.InterceptDual getClassInterceptDual(ClassElement clazz) {
  clazz.metadata
      .forEach((ElementAnnotation annot) => annot.computeConstantValue());
  var matchingAnnotations = clazz.metadata
      .map((ElementAnnotation annot) => instantiateAnnotation(annot))
      .where((dynamic instance) => instance is ant.InterceptDual)
      .toList();

  if (matchingAnnotations.isEmpty) {
    return null;
  } else if (matchingAnnotations.length > 1) {
    throw 'Cannot define InterceptDual more than once';
  }

  return matchingAnnotations[0];
}

///Parse interceptors for a given method or class element
List<InterceptorInfo> parseInterceptor(Element element) {
  return element.metadata
      .map((ElementAnnotation annot) {
        if (!isAnnotationInterceptDual(annot)) {
          return null;
        }

        return new DualInterceptorInfo(annot);
      })
      .where((dynamic val) => val != null)
      .toList();
}
