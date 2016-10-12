library jaguar.generator.pre_interceptor;

import '../parameter.dart';
import '../utils.dart';
import '../post_interceptors/post_interceptor.dart';

abstract class PreInterceptor {
  final String returnType;
  final String variableName;
  final String functionName;
  final List<Parameter> parameters;
  final List<String> methods;
  final List<PostInterceptor> callPostInterceptorsAfter;
  final bool allowMultiple;

  const PreInterceptor(
      {this.returnType: null,
      this.variableName: null,
      this.functionName: null,
      this.parameters: const <Parameter>[],
      this.methods: const <String>[
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
      ],
      this.callPostInterceptorsAfter: const <PostInterceptor>[],
      this.allowMultiple: false});

  void generateCall(StringBuffer sb, int numberPreInterceptor) {
    bool needAwait = false;
    String type = returnType;
    if (returnType.startsWith("Future")) {
      type = getTypeFromFuture(returnType);
      needAwait = true;
    }
    if (type != "void" && type != "Null") {
      sb.write("$type $variableName$numberPreInterceptor = ");
    }
    if (needAwait) {
      sb.write("await ");
    }
    sb.write("$functionName(");
    fillParameters(sb);
    sb.write(")");
    sb.writeln(";");
  }

  void fillParameters(StringBuffer sb) {
    parameters.forEach((Parameter parameter) {
      if (parameter.name != null) {
        sb.write("${parameter.name},");
      }
    });
  }

  void callInterceptor(StringBuffer sb, int numberPreInterceptor,
      [bool insideParameter = false]) {
    generateCall(sb, numberPreInterceptor);
  }
}
