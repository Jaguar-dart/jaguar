part of jaguar.generator.internal.element;

class ConstructorElementWrap {
  ConstructorElementWrap(this._wrapped) {
    for (ParameterElement param in parameters) {
      if (param.parameterKind.isOptional) {
        _optionalParams.add(param);

        _areOptionalParamsPositional =
            param.parameterKind == ParameterKind.POSITIONAL;
      } else {
        _requiredParams.add(param);
      }
    }
  }

  final ConstructorElement _wrapped;

  List<ElementAnnotation> get metadata => _wrapped.metadata;

  List<ParameterElement> _requiredParams = <ParameterElement>[];

  List<ParameterElement> _optionalParams = <ParameterElement>[];

  bool _areOptionalParamsPositional = false;

  String get name => _wrapped.name;

  List<ParameterElement> get parameters => _wrapped.parameters;

  List<ParameterElement> get requiredParameters => _requiredParams;

  List<ParameterElement> get optionalParameters => _optionalParams;

  bool get areOptionalParamsPositional => _areOptionalParamsPositional;

  ParameterElement findOptionalParamByName(String paramName) {
    for (ParameterElement param in _optionalParams) {
      if (param.name == paramName) {
        return param;
      }
    }

    return null;
  }
}
