part of jaguar.generator.parser.interceptor;

/// Holds information about interceptor functions
class InterceptorFuncDef {
  /// The function or method element
  MethodElement method;

  DartType get returnType => method.returnType;

  bool get returnsVoid => returnType.isVoid;

  bool get returnsFuture => returnType.isDartAsyncFuture;

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
        .map(instantiateInputAnnotation)
        .where((InputInfo instance) => instance is InputInfo)
        .forEach((InputInfo inp) => inputs.add(inp));
  }

  /// Debug printer
  String toString() {
    String lRet = method.name +
        '(' +
        inputs.map((InputInfo inp) => '$inp}').join(',') +
        ')';
    return lRet;
  }
}

class InterceptorFuncInfo implements InterceptorInfo {
  InterceptorFuncDef definition;

  bool isPost;

  DartType returns;

  InterceptorFuncInfo(this.definition, {this.isPost: false});
}
