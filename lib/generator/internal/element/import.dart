library jaguar.generator.internal.element;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/generated/utilities_dart.dart';

class MethodElementWrap {
  MethodElementWrap(this._wrapped) {
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

  final MethodElement _wrapped;

  List<ParameterElement> _requiredParams = <ParameterElement>[];

  List<ParameterElement> _optionalParams = <ParameterElement>[];

  bool _areOptionalParamsPositional = false;

  String get prototype {
    StringBuffer sb = new StringBuffer();
    sb.write(returnType.toString() + " ");
    sb.write(name + "(");

    if (_requiredParams.length != 0) {
      String paramsStr = _requiredParams
          .map((ParameterElement pel) => pel.toString())
          .join(",");

      sb.write(paramsStr);

      if (_optionalParams.length != 0) {
        sb.write(',');
      }
    }

    if (_optionalParams.length != 0) {
      if (_areOptionalParamsPositional) {
        sb.write('[');
      } else {
        sb.write('{');
      }

      String paramsStr = _optionalParams.map((ParameterElement pel) {
        final str = pel.toString();
        return str.substring(1, str.length-1);
      }).join(",");

      sb.write(paramsStr);

      if (_areOptionalParamsPositional) {
        sb.write(']');
      } else {
        sb.write('}');
      }
    }

    sb.writeln(");");
    return sb.toString();
  }

  String get name => _wrapped.name;

  List<ParameterElement> get parameters => _wrapped.parameters;

  List<ParameterElement> get requiredParameters => _requiredParams;

  List<ParameterElement> get optionalParameters => _optionalParams;

  bool get areOptionalParamsPositional => _areOptionalParamsPositional;

  DartType get returnType => _wrapped.returnType;

  DartType get returnTypeWithoutFuture =>
      returnType.flattenFutures(_wrapped.context.typeSystem);
}
