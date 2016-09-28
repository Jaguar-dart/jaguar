library jaguar.annotations;

import '../generator/processor.dart';
import '../generator/pre_processor.dart';
import '../generator/post_processor.dart';

class Api extends Processor {
  final String name;
  final String version;

  const Api({this.name, this.version});

  String toString() => "$name $version";
}

class Route extends Processor {
  final String path;

  final List<String> methods;

  const Route({this.path: '', this.methods});
}

class Group extends Processor {
  final String path;

  const Group({this.path: ''});
}

class MustBeContentType extends PreProcessor {
  final String contentType;

  const MustBeContentType({this.contentType: 'text/plain'});
}

class GetRawDataFromBody extends PreProcessor {
  final String encoding;

  const GetRawDataFromBody({this.encoding: 'utf-8'});
}

class DecodeBodyToJson extends PreProcessor {
  final String contentType;
  final String charset;

  const DecodeBodyToJson(
      {this.contentType: 'application/json', this.charset: ''});
}

class OpenMongoDb extends PreProcessor {
  final String uri;
  final String dbName;

  const OpenMongoDb({this.uri: 'mongodb://localhost:27017/', this.dbName});
}

class EncodeResponseToJson extends PostProcessor {
  const EncodeResponseToJson();
}

class CloseMongoDb extends PostProcessor {
  const CloseMongoDb();
}
