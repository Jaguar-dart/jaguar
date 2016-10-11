library jaguar.generator.route.route_information_processor;

import '../parameter.dart';
import '../../src/interceptors/interceptors.dart';
import '../pre_interceptors/pre_interceptor.dart';
import '../utils.dart';

class RouteInformationsProcessor extends Interceptor {
  final String path;
  final List<String> methods;
  final List<Parameter> parameters;
  final List<Parameter> namedParameters;
  final String returnType;
  final String functionName;

  const RouteInformationsProcessor(
      {this.path,
      this.methods,
      this.parameters,
      this.namedParameters,
      this.returnType,
      this.functionName})
      : super();

  void fillParameters(StringBuffer sb, List<PreInterceptor> preProcessors) {
    if (parameters.isEmpty) return;
    if (parameters.first.typeAsString == 'HttpRequest') {
      sb.write("request, ");
      parameters.removeAt(0);
    }
    Map<String, int> numberPreProcessor = <String, int>{};
    preProcessors.forEach((PreInterceptor preProcessor) {
      String type = preProcessor.runtimeType.toString();
      if (!numberPreProcessor.containsKey(type)) {
        numberPreProcessor[type] = 0;
      } else {
        numberPreProcessor[type] += 1;
      }
      sb.write("${preProcessor.variableName}${numberPreProcessor[type]}, ");
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

  void callProcessor(StringBuffer sb, List<PreInterceptor> preProcessor) {
    if (returnType.startsWith("Future")) {
      String type = getTypeFromFuture(returnType);
      manageType(sb, type, true, preProcessor);
    } else {
      manageType(sb, returnType, false, preProcessor);
    }
  }

  void manageType(StringBuffer sb, String type, bool needAwait,
      List<PreInterceptor> preProcessors) {
    if (type == "void") {
      sb.write("$functionName(");
      fillParameters(sb, preProcessors);
      sb.writeln(");");
    } else if (type == "dynamic") {
      sb.write("var result = ${needAwait ? 'await ' : ''} $functionName(");
      fillParameters(sb, preProcessors);
      sb.writeln(");");
    } else {
      sb.write("$type result = ${needAwait ? 'await ' : ''}$functionName(");
      fillParameters(sb, preProcessors);
      sb.writeln(");");
    }
  }

  String generateCall(List<PreInterceptor> preProcessors) {
    StringBuffer sb = new StringBuffer();

    callProcessor(sb, preProcessors);

    return sb.toString();
  }
}
