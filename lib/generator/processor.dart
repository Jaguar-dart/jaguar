library jaguar.generators.processor;

import 'utils.dart';

class Parameter {
  final String type;
  final String name;

  const Parameter(this.type, this.name);

  String toString() => "$type $name";
}

abstract class Processor {
  final List<Parameter> parameters;
  final List<Parameter> namedParameters;
  final String variableName;
  final String returnType;
  final String functionName;
  final List<dynamic> dependsOn;

  const Processor(
      {this.dependsOn: const <dynamic>[],
      this.parameters: const <Parameter>[],
      this.namedParameters: const <Parameter>[],
      this.returnType,
      this.functionName,
      this.variableName});

  void callProcessor(StringBuffer sb) {
    if (returnType.startsWith("Future")) {
      String type = getTypeFromFuture(returnType);
      manageType(sb, type, true);
    } else {
      manageType(sb, returnType, false);
    }
  }

  void manageType(StringBuffer sb, String type, bool needAwait) {
    if (type == "void" || variableName == null) {
      sb.write("$functionName(");
      fillParameters(sb);
      sb.writeln(");");
    } else if (type == "dynamic") {
      sb.write(
          "var $variableName = ${needAwait ? 'await ' : ''} $functionName(");
      fillParameters(sb);
      sb.writeln(");");
    } else {
      sb.write(
          "$type $variableName = ${needAwait ? 'await ' : ''}$functionName(");
      fillParameters(sb);
      sb.writeln(");");
    }
  }

  void fillParameters(StringBuffer sb) {
    parameters.forEach((Parameter parameter) {
      sb.write("${parameter.name},");
    });
  }

  void generateFunction(StringBuffer sb) {}

  String generateCall() {
    StringBuffer sb = new StringBuffer();

    callProcessor(sb);

    return sb.toString();
  }
}

class RouteInformationsProcessor extends Processor {
  String path;
  List<String> methods;
  List<String> preProcessorVariableName;

  RouteInformationsProcessor(
      {this.path,
      this.methods,
      this.preProcessorVariableName,
      List<Parameter> parameters,
      List<Parameter> namedParameters,
      String returnType,
      String functionName})
      : super(
            parameters: parameters,
            namedParameters: namedParameters,
            returnType: returnType,
            functionName: functionName,
            variableName: 'result');

  @override
  void fillParameters(StringBuffer sb) {
    if (parameters.first.type == 'HttpRequest') {
      sb.write("request, ");
      parameters.removeAt(0);
    }
    if (parameters.length >= preProcessorVariableName.length) {
      preProcessorVariableName.forEach((String name) {
        sb.write("$name, ");
        parameters.removeAt(0);
      });
    }
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

  void generateFunction(StringBuffer sb) {}
}
