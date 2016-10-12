library jaguar.generator.post_interceptor;

import '../parameter.dart';
import '../utils.dart';

abstract class PostInterceptor {
  final String returnType;
  final String variableName;
  final String functionName;
  final List<Parameter> parameters;
  final bool allowMultiple;
  final bool takeResponse;

  const PostInterceptor(
      {this.returnType: null,
      this.variableName: null,
      this.functionName: null,
      this.parameters: const <Parameter>[],
      this.allowMultiple: false,
      this.takeResponse: false});

  void generateCall(StringBuffer sb, int numberPostInterceptor) {
    bool needAwait = false;
    String type = returnType;
    if (returnType.startsWith("Future")) {
      type = getTypeFromFuture(returnType);
      needAwait = true;
    }
    if (type != "void" && type != "Null") {
      sb.write("$type $variableName$numberPostInterceptor = ");
    }
    if (needAwait) {
      sb.write("await ");
    }
    sb.write("$functionName(");
    fillParameters(sb, numberPostInterceptor);
    sb.write(")");
    sb.writeln(";");
  }

  void fillParameters(StringBuffer sb, int numberPostInterceptor) {
    parameters.forEach((Parameter parameter) {
      if (parameter.name != null) {
        if (parameter.name == "request" || parameter.name == "result") {
          sb.write("${parameter.name},");
        } else {
          sb.write("${parameter.name}$numberPostInterceptor,");
        }
      }
    });
  }

  void callInterceptor(StringBuffer sb, int numberPostInterceptor,
      [bool insideParameter = false]) {
    generateCall(sb, numberPostInterceptor);
  }
}
