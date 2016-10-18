part of  jaguar.generator.parser.interceptor;

/// Holds information about interceptor functions
class InterceptorFuncDef {
  /// The function or method element
  MethodElement method;

  /// Inputs declared on the interceptor
  List<InputInfo> inputs = <InputInfo>[];

  /// Default constructor. Constructs [InterceptorFuncDef] from the given
  /// method element
  InterceptorFuncDef(this.method) {
    /// Initialize constant values
    method.metadata
        .forEach((ElementAnnotation annot) => annot.computeConstantValue());

    /// Find and collect Inputs to the interceptor
    method.metadata
        .map((ElementAnnotation annot) => instantiateAnnotation(annot))
        .where((dynamic instance) => instance is ant.Input)
        .forEach((ant.Input inp) => inputs.add(new InputInfo.FromAnnot(inp)));
  }

  /// Debug printer
  String toString() {
    String lRet = "(" + inputs.map((InputInfo inp) => '$inp}').join(',') + ')';
    return lRet;
  }
}

class InterceptorFuncInfo implements InterceptorInfo {
  InterceptorFuncDef definition;

  bool isPost;

  Type returns;

  InterceptorFuncInfo(this.definition, {this.isPost: false});
}