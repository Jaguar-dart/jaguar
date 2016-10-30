library jaguar.generator.internal.element;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/constant/value.dart';
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

class DartTypeWrap {
  final DartType _wrapped;

  DartTypeWrap(this._wrapped);

  bool get isInt => _compare(kIntTypeName, kCoreLibraryName);

  bool get isDouble => _compare(kDoubleTypeName, kCoreLibraryName);

  bool get isNum => _compare(kNumTypeName, kCoreLibraryName);

  bool get isBool => _compare(kBoolTypeName, kCoreLibraryName);

  bool get isString => _compare(kStringTypeName, kCoreLibraryName);

  bool get isBuiltin => isInt || isDouble || isNum || isBool || isString;

  String get name => _wrapped.name;

  String get libraryName => _wrapped.element.library.name;

  static const String kCoreLibraryName = 'dart.core';

  static const String kIntTypeName = 'int';

  static const String kDoubleTypeName = 'double';

  static const String kNumTypeName = 'num';

  static const String kBoolTypeName = 'bool';

  static const String kStringTypeName = 'String';

  bool _compare(String aName, String aLibraryName) => aName == name && aLibraryName == libraryName;
}

class ParameterElementWrap {
  final ParameterElement _wrapped;

  ParameterElementWrap(this._wrapped) {
    _type = new DartTypeWrap(_wrapped.type);
  }

  DartTypeWrap _type;

  dynamic get toValueIfBuiltin {
    if(!_type.isBuiltin) {
      return null;
    }

    DartObject value = _wrapped.constantValue;

    if(_type.isInt) {
      return value.toIntValue();
    } else if(_type.isDouble) {
      return value.toDoubleValue();
    } else if(_type.isString) {
      return value.toStringValue();
    } else if(_type.isBool) {
      return value.toBoolValue();
    }

    return null;
  }

  String get name => _wrapped.name;
}