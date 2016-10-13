library jaguar.generator.route_informations_processor;

import '../parameter.dart';
import '../../src/interceptors/interceptors.dart';
import '../pre_interceptors/pre_interceptor.dart';
import '../utils.dart';

class RouteInformationsInterceptor extends Interceptor {
  final String path;
  final List<String> methods;
  final List<Parameter> parameters;
  final List<Parameter> namedParameters;
  final String returnType;
  final String functionName;

  const RouteInformationsInterceptor(
      {this.path,
      this.methods,
      this.parameters,
      this.namedParameters,
      this.returnType,
      this.functionName})
      : super();

  void fillParameters(StringBuffer sb, List<PreInterceptor> preInterceptors) {
    if (parameters.isEmpty) return;
    if (parameters.first.typeAsString == 'HttpRequest') {
      sb.write("request,");
      parameters.removeAt(0);
    }
    Map<String, int> numberPreInterceptor = <String, int>{};
    preInterceptors.forEach((PreInterceptor preInterceptor) {
      String type = preInterceptor.runtimeType.toString();
      if (!numberPreInterceptor.containsKey(type)) {
        numberPreInterceptor[type] = 0;
      } else {
        numberPreInterceptor[type] += 1;
      }
      sb.write("${preInterceptor.variableName}${numberPreInterceptor[type]}, ");
      parameters.removeAt(0);
    });
    for (int i = 0; i < parameters.length; i++) {
      sb.write("args[${i}], ");
    }

    namedParameters.forEach((Parameter param) {
      if (param.type == "String") {
        sb.write("${param.name}: request.uri.queryParameters['${param.name}']");
      } else if (param.type == "int") {
        sb.write(
            "${param.name}: int.parse(request.uri.queryParameters['${param.name}'])");
      } else if (param.type == "double") {
        sb.write(
            "${param.name}: double.parse(request.uri.queryParameters['${param.name}'])");
      } else if (param.type == "num") {
        sb.write(
            "${param.name}: num.parse(request.uri.queryParameters['${param.name}'])");
      }
    });
  }

  void callInterceptor(StringBuffer sb, List<PreInterceptor> preInterceptor) {
    if (returnType.startsWith("Future")) {
      String type = getTypeFromFuture(returnType);
      manageType(sb, type, true, preInterceptor);
    } else {
      manageType(sb, returnType, false, preInterceptor);
    }
  }

  void manageType(StringBuffer sb, String type, bool needAwait,
      List<PreInterceptor> preInterceptors) {
    if (type == "void" || type == "Null") {
      sb.write("${needAwait ? 'await ' : ''}$functionName(");
      fillParameters(sb, preInterceptors);
      sb.writeln(");");
    } else if (type == "dynamic") {
      sb.write("var result = ${needAwait ? 'await ' : ''}$functionName(");
      fillParameters(sb, preInterceptors);
      sb.writeln(");");
    } else {
      sb.write("$type result = ${needAwait ? 'await ' : ''}$functionName(");
      fillParameters(sb, preInterceptors);
      sb.writeln(");");
    }
  }

  String generateCall(List<PreInterceptor> preInterceptors) {
    StringBuffer sb = new StringBuffer();

    callInterceptor(sb, preInterceptors);

    return sb.toString();
  }
}
