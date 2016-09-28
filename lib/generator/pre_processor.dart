library jaguar.generator.pre_processor;

import 'dart:io';

import 'processor.dart';

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

class OpenMongoDbPreProcessor extends PreProcessor {
  OpenMongoDbPreProcessor({String uri, String dbName})
      : super(
            parameters: <Parameter>[
              new Parameter("String", "'$uri'"),
              new Parameter('String', "'$dbName'")
            ],
            returnType: 'Future<Db>',
            variableName: 'mongoDb',
            functionName: 'getMongoDbInstance');

  void generaFunction(StringBuffer sb) {
    sb.writeln(
        "Future<Db> getMongoDbInstance(String uri, String dbName) async {");
    sb.writeln("Db db = new Db('\$uri\$dbName');");
    sb.writeln("await db.open();");
    sb.writeln("return db;");
    sb.writeln("}");
    sb.writeln("");
  }
}
