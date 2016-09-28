library jaguar.generators.processor;

import 'dart:io';

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

abstract class PreProcessor extends Processor {
  final List<String> authorizedMethods;

  const PreProcessor(
      {this.authorizedMethods: const <String>[
        'GET',
        'POST',
        'PUT',
        'DELETE',
        'OPTIONS'
      ],
      List<dynamic> dependsOn: const <dynamic>[],
      List<Parameter> parameters: const <Parameter>[],
      String returnType,
      String functionName,
      String variableName})
      : super(
            dependsOn: dependsOn,
            parameters: parameters,
            returnType: returnType,
            functionName: functionName,
            variableName: variableName);
}

class MustBeContentTypePreProcessor extends PreProcessor {
  MustBeContentTypePreProcessor({String contentType})
      : super(
            parameters: <Parameter>[
              new Parameter('HttpRequest', 'request'),
              new Parameter('ContentType', "ContentType.parse('$contentType')")
            ],
            returnType: 'void',
            functionName: 'mustBeContentType',
            authorizedMethods: const <String>['POST']);

  void generateFunction(StringBuffer sb) {
    sb.writeln(
        "void mustBeContentType(HttpRequest request, ContentType contentType) {");
    sb.writeln("if (request.headers.contentType.value != contentType.value) {");
    sb.writeln("String value = request.headers.contentType?.value ?? '';");
    sb.writeln(
        "throw new BadRequestError('The request has content type \$value instead of \$contentType');");
    sb.writeln("}");
    sb.writeln(
        "if (contentType.charset != null && request.headers.contentType.charset != contentType.charset) {");
    sb.writeln("String value = request.headers.contentType?.charset ?? '';");
    sb.writeln(
        "throw new BadRequestError('The request has charset \$value instead of \${contentType.charset}');");
    sb.writeln("}");
    sb.writeln("}");
    sb.writeln("");
  }
}

void getDataFromBodyBase(StringBuffer sb, String encoder) {
  sb.writeln(
      "Future<String> getDataFromBodyInUtf8(HttpRequest request) async {");
  sb.writeln("Completer<String> completer = new Completer<String>();");
  sb.writeln("String datas = '';");
  sb.writeln("request.transform($encoder.decoder).listen((String data) {");
  sb.writeln("datas += data;");
  sb.writeln("}, onDone: () => completer.complete(datas)");
  sb.writeln(", onError: (dynamic error) => completer.completeError(error));");
  sb.writeln("return completer.future;");
  sb.writeln("}");
  sb.writeln("");
}

class GetDataFromBodyInUtf8PreProcessor extends PreProcessor {
  GetDataFromBodyInUtf8PreProcessor()
      : super(
            parameters: <Parameter>[new Parameter('HttpRequest', 'request')],
            authorizedMethods: const <String>['POST'],
            returnType: 'Future<String>',
            variableName: 'data',
            functionName: 'getDataFromBody');

  void generateFunction(StringBuffer sb) {
    getDataFromBodyBase(sb, 'UTF8');
  }
}

void decodeBodyToJsonFunctionBase(
    StringBuffer sb, String encoding, ContentType contentType) {
  sb.writeln(
      "Future<dynamic> getJsonFromBodyIn$encoding(HttpRequest request) async {");
  sb.write(
      "mustBeContentType(request, ContentType.parse('${contentType.value}");
  if (contentType.charset != null) {
    sb.writeln("; charset=${contentType.charset}'));");
  } else {
    sb.writeln("'));");
  }
  sb.writeln("if (request.contentLength <= 0) {");
  sb.writeln("return null;");
  // sb.writeln("throw new BadRequestError('Your json is empty');");
  sb.writeln("}");
  sb.writeln("String data = await getDataFromBodyIn$encoding(request);");
  sb.writeln("return JSON.decode(data);");
  sb.writeln("}");
  sb.writeln("");
}

class DecodeBodyToJsonInUtf8PreProcessor extends PreProcessor {
  ContentType _contentType;

  DecodeBodyToJsonInUtf8PreProcessor({ContentType contentType})
      : super(
            dependsOn: <PreProcessor>[
              new MustBeContentTypePreProcessor(contentType: contentType.value),
              new GetDataFromBodyInUtf8PreProcessor()
            ],
            authorizedMethods: const <String>[
              'POST',
              'PUT',
              'DELETE',
              'OPTIONS'
            ],
            parameters: <Parameter>[
              new Parameter('HttpRequest', 'request')
            ],
            returnType: "Future<dynamic>",
            variableName: 'json',
            functionName: 'getJsonFromBodyInUtf8') {
    _contentType = contentType;
  }

  void generateFunction(StringBuffer sb) {
    decodeBodyToJsonFunctionBase(sb, 'Utf8', _contentType);
  }
}

abstract class PostProcessor extends Processor {
  const PostProcessor(
      {List<Parameter> parameters,
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
