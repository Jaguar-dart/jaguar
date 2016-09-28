library jaguar.generator.post_processor;

import 'processor.dart';

abstract class PostProcessor extends Processor {
  const PostProcessor(
      {List<Parameter> parameters: const <Parameter>[],
      String returnType,
      String functionName,
      String variableName})
      : super(
            parameters: parameters,
            returnType: returnType,
            functionName: functionName,
            variableName: variableName);
}

class EncodeResponseToJsonPostProcessor extends PostProcessor {
  const EncodeResponseToJsonPostProcessor()
      : super(
            parameters: const <Parameter>[const Parameter('dynamic', 'result')],
            returnType: 'String',
            variableName: 'response',
            functionName: 'getJsonFromResponse');

  void generateFunction(StringBuffer sb) {
    sb.writeln("String getJsonFromResponse(dynamic data) {");
    sb.writeln("return JSON.encode(data);");
    sb.writeln("}");
  }
}

class CloseMongoDbPostProcessor extends PostProcessor {
  const CloseMongoDbPostProcessor()
      : super(returnType: 'void', functionName: 'await mongoDb.close');
}
