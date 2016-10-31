library jaguar.generator.internal.element;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:analyzer/src/generated/utilities_dart.dart';

/// An element that has a name and library
abstract class NamedElement {
  String get name;

  String get libraryName;
}

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

  List<ElementAnnotation> get metadata => _wrapped.metadata;

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
        return str.substring(1, str.length - 1);
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

  bool get isInt => compare(kIntTypeName, kCoreLibraryName);

  bool get isDouble => compare(kDoubleTypeName, kCoreLibraryName);

  bool get isNum => compare(kNumTypeName, kCoreLibraryName);

  bool get isBool => compare(kBoolTypeName, kCoreLibraryName);

  bool get isString => compare(kStringTypeName, kCoreLibraryName);

  bool get isBuiltin => isInt || isDouble || isNum || isBool || isString;

  String get name => _wrapped.name;

  String get libraryName => _wrapped.element.library.name;

  bool isType(DartTypeWrap other) {
    if (libraryName != other.libraryName) {
      return false;
    }

    if (name != other.name) {
      return false;
    }

    return true;
  }

  static const String kCoreLibraryName = 'dart.core';

  static const String kIntTypeName = 'int';

  static const String kDoubleTypeName = 'double';

  static const String kNumTypeName = 'num';

  static const String kBoolTypeName = 'bool';

  static const String kStringTypeName = 'String';

  bool compare(String aName, String aLibraryName) =>
      aName == name && aLibraryName == libraryName;
}

class ParameterElementWrap {
  final ParameterElement _wrapped;

  ParameterElementWrap(this._wrapped) {
    _type = new DartTypeWrap(_wrapped.type);
  }

  DartTypeWrap _type;

  DartTypeWrap get type => _type;

  dynamic get toValueIfBuiltin {
    if (!_type.isBuiltin) {
      return null;
    }

    DartObject value = _wrapped.constantValue;

    if (_type.isInt) {
      return value.toIntValue();
    } else if (_type.isDouble) {
      return value.toDoubleValue();
    } else if (_type.isString) {
      return value.toStringValue();
    } else if (_type.isBool) {
      return value.toBoolValue();
    }

    return null;
  }

  String get name => _wrapped.name;
}

class AnnotationElementWrap {
  final ElementAnnotation _wrapped;

  AnnotationElementWrap(this._wrapped);

  DartObject get constantValue => _wrapped.constantValue;

  String get libraryName => constantValue.type.element.library.displayName;

  String get displayName => constantValue.type.displayName;

  String get instantiationString {
    String lRet = (_wrapped as ElementAnnotationImpl).annotationAst.toSource();
    lRet = lRet.substring(1);
    return ' new ' + lRet;
  }
}
