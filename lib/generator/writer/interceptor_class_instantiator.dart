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

  void _generateExperimental() {
    _w.write(_i.interceptor.name + " ");
    _w.write(_i.genInstanceName + " = new ");

    ElementAnnotationImpl element = _i.element;
    ConstructorElementWrap construct =
        new ConstructorElementWrap(element.element);
    AnnotationImpl ast = element.annotationAst;
    _w.write(ast.name);
    _w.write('(');

    bool hasAssignedState = false;

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
        Map<String, ParameterElement> paramsAssigned = {};

        for (; index < ast.arguments.arguments.length; index++) {
          NamedExpressionImpl astItem = ast.arguments.arguments[index];

          _w.write(astItem);
          _w.write(', ');

          final String name = astItem.name.label.name;

          paramsAssigned[name] = construct.findOptionalParamByName(name);

          if (name == 'state') {
            hasAssignedState = true;
          }
        }

        _i.interceptor.params.forEach((String name, DartTypeWrap type) {
          if (construct.findOptionalParamByName(name) != null) {
            //TODO check if it is assignable
            _w.write(name + ': ');
            _w.write('new ' + type.displayName + '(),');
          }
        });
      } else {
        hasAssignedState = true;
        //We don't inject in names params
      }
    }

    if (!hasAssignedState) {
      //Check if interceptor has state and can be assigned
      if (_i.canCreateState && _i.needsState) {
        _w.write('state: ${_i.interceptor.name}.createState()');
      }
    }

    //TODO

    _w.write(')');
    _w.writeln(";");
  }

  String get code => _w.toString();
}
