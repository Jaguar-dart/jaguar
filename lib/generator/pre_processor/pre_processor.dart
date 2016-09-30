library jaguar.generator.pre_processor;

import '../parameter.dart';
import '../utils.dart';
import '../post_processor/post_processor.dart';

abstract class PreProcessor {
  final String returnType;
  final String variableName;
  final String functionName;
  final List<Parameter> parameters;
  final List<String> methods;
  final List<String> postProcessors;
  final bool allowMultiple;

  const PreProcessor(
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
      this.postProcessors: const <String>[],
      this.allowMultiple: false});

  void generateCall(StringBuffer sb, int numberPreProcessor) {
    bool needAwait = false;
    String type = returnType;
    if (returnType.startsWith("Future")) {
      type = getTypeFromFuture(returnType);
      needAwait = true;
    }
    if (type != "void" && type != "Null") {
      sb.write("$type $variableName$numberPreProcessor = ");
    }
    if (needAwait) {
      sb.write("await ");
    }
    sb.write("$functionName(");
    fillParameters(sb);
    sb.write(")");
    // if (!insideParameter) {
    sb.writeln(";");
    // } else {
    //   sb.writeln(",");
    // }
  }

  void fillParameters(StringBuffer sb) {
    parameters.forEach((Parameter parameter) {
      if (parameter.name != null) {
        sb.write("${parameter.name},");
      }
    });
  }

  void callProcessor(StringBuffer sb, int numberPreProcessor,
      [bool insideParameter = false]) {
    generateCall(sb, numberPreProcessor);
  }
}
