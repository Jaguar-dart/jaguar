library jaguar.generator.post_processor;

import '../parameter.dart';
// import '../pre_processor/pre_processor.dart';
import '../utils.dart';

abstract class PostProcessor {
  final String returnType;
  final String variableName;
  final String functionName;
  final List<Parameter> parameters;
  // final List<String> preProcessors;
  final bool allowMultiple;
  final bool takeResponse;

  const PostProcessor(
      {this.returnType: null,
      this.variableName: null,
      this.functionName: null,
      this.parameters: const <Parameter>[],
      // this.preProcessors: const <String>[],
      this.allowMultiple: false,
      this.takeResponse: false});

  void generateCall(StringBuffer sb, int numberPostProcessor) {
    bool needAwait = false;
    String type = returnType;
    if (returnType.startsWith("Future")) {
      type = getTypeFromFuture(returnType);
      needAwait = true;
    }
    if (type != "void" && type != "Null") {
      sb.write("$type $variableName$numberPostProcessor = ");
    }
    if (needAwait) {
      sb.write("await ");
    }
    sb.write("$functionName(");
    fillParameters(sb, numberPostProcessor);
    sb.write(")");
    sb.writeln(";");
  }

  void fillParameters(StringBuffer sb, int numberPostProcessor) {
    parameters.forEach((Parameter parameter) {
      if (parameter.name != null) {
        if (parameter.name == "request" || parameter.name == "result") {
          sb.write("${parameter.name},");
        } else {
          sb.write("${parameter.name}$numberPostProcessor,");
        }
      }
    });
  }

  void callProcessor(StringBuffer sb, int numberPostProcessor,
      [bool insideParameter = false]) {
    generateCall(sb, numberPostProcessor);
  }
}
