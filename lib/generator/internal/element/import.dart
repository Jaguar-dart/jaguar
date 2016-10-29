library jaguar.generator.internal.element;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

class MethodElementWrap {
  MethodElementWrap(this._wrapped);

  final MethodElement _wrapped;

  String get prototype {
    StringBuffer sb = new StringBuffer();
    sb.write(returnType.toString() + " ");
    sb.write(name + "(");
    String paramsStr = parameters
        .map((ParameterElement pel) => pel.toString())
        .join(", ");
    sb.writeln(paramsStr + ");");
    return sb.toString();
  }

  String get name => _wrapped.name;

  List<ParameterElement> get parameters => _wrapped.parameters;

  DartType get returnType => _wrapped.returnType;

  DartType get returnTypeWithoutFuture => returnType.flattenFutures(_wrapped.context.typeSystem);
}
