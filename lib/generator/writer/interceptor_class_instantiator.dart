part of jaguar.generator.writer;

class InterceptorClassDecl {
  /// Route of the interceptor
  final RouteInfo _r;

  /// Interceptor for which instantiation code is being generated
  final InterceptorClassInfo _i;

  /// String buffer to write the result to
  StringBuffer _w = new StringBuffer();

  InterceptorClassDecl(this._r, this._i) {
    _generateExperimental();
  }

  void _generate() {
    _w.write(_i.instantiationString);
  }

  void _generateExperimental() {
    _w.write(_i.interceptor.name + " ");
    _w.write(_i.genInstanceName + " = new ");

    ElementAnnotationImpl element = _i.elememt;
    ConstructorElementImpl construct = element.element;
    AnnotationImpl ast = element.annotationAst;
    _w.write(ast.name);
    _w.write('(');

    bool hasAssignedState = false;

    Map<String, ParameterElement> optionalParams = {};

    int index = 0;
    for (index = 0; index < construct.parameters.length; index++) {
      ParameterElement param = construct.parameters[index];

      if (param.parameterKind.isOptional) {
        break;
      }

      final astItem = ast.arguments.arguments[index];

      _w.write(astItem);
      _w.write(', ');
    }

    if (index < construct.parameters.length &&
        index < ast.arguments.arguments.length) {
      if (construct.parameters[index].parameterKind == ParameterKind.NAMED) {
        for (; index < ast.arguments.arguments.length; index++) {
          NamedExpressionImpl astItem = ast.arguments.arguments[index];

          _w.write(astItem);
          _w.write(', ');

          if (astItem.name.label.name == 'state') {
            hasAssignedState = true;
          }
        }
      } else {
        for (; index < ast.arguments.arguments.length; index++) {
          ParameterElement param = construct.parameters[index];

          final astItem = ast.arguments.arguments[index];

          _w.write(astItem);
          _w.write(', ');

          if (param.name == 'state') {
            hasAssignedState = true;
          }
        }
      }
    }

    if (!hasAssignedState) {
      //Check if interceptor has state and can be assigned
      print('check');
      //TODO
    } else {
      print('no check');
    }

    //TODO

    _w.write(')');
    _w.writeln(";");
  }

  String get code => _w.toString();
}
