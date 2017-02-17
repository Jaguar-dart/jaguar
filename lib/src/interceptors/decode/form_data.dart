part of jaguar.src.interceptors;

abstract class FormField {
  String get name;

  dynamic get value;

  ContentType get contentType;

  int get hashCode => name.hashCode;
}

class StringFormField implements FormField {
  final String name;

  final String value;

  final ContentType contentType;

  StringFormField(this.name, this.value, {this.contentType});

  bool operator ==(other) {
    if (other is! StringFormField) {
      return false;
    }

    return _equality(other as StringFormField);
  }

  bool _equality(StringFormField other) {
    return name == other.name &&
        value == other.value &&
        contentType.mimeType == other.contentType.mimeType &&
        contentType.charset == other.contentType.charset;
  }

  int get hashCode => name.hashCode;

  String toString() {
    return "StringFormField('$name', '$value', '$contentType')";
  }
}

class TextFileFormField implements FormField {
  final String name;

  final Stream<String> value;

  final ContentType contentType;

  final String filename;

  TextFileFormField(this.name, this.value, {this.contentType, this.filename});

  bool operator ==(other) {
    return name == other.name &&
        contentType.mimeType == other.contentType.mimeType &&
        contentType.charset == other.contentType.charset &&
        filename == other.filename;
  }

  int get hashCode => name.hashCode;

  String toString() {
    return "FileFormField('$name', '$contentType', '$filename')";
  }
}

class BinaryFileFormField implements FormField {
  final String name;

  final Stream<List<int>> value;

  final ContentType contentType;

  final String filename;

  BinaryFileFormField(this.name, this.value, {this.contentType, this.filename});

  bool operator ==(other) {
    return name == other.name &&
        contentType.mimeType == other.contentType.mimeType &&
        contentType.charset == other.contentType.charset &&
        filename == other.filename;
  }

  int get hashCode => name.hashCode;

  String toString() {
    return "FileFormField('$name', '$contentType', '$filename')";
  }
}

class WrapDecodeFormData extends RouteWrapper<DecodeFormData> {
  final String id;

  const WrapDecodeFormData({this.id});

  DecodeFormData createInterceptor() => new DecodeFormData();
}

class DecodeFormData extends Interceptor {
  DecodeFormData();

  Future<Map<String, FormField>> pre(Request request) async {
    if (!request.headers.contentType.parameters.containsKey('boundary')) {
      return null;
    }

    final String boundary = request.headers.contentType.parameters['boundary'];

    final Map<String, FormField> ret = {};

    final Stream<List<int>> bodyStream = await request.bodyAsStream;

    // Transform body to [MimeMultipart]
    final transformer = new MimeMultipartTransformer(boundary);
    final Stream<MimeMultipart> stream = bodyStream.transform(transformer);

    await for (MimeMultipart part in stream) {
      HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);

      // Parse field content type
      final ContentType contentType = multipart.contentType;

      final String name = multipart.contentDisposition.parameters['name'];

      final String fn = multipart.contentDisposition.parameters['filename'];

      // Create field
      if (fn is! String && multipart.isText) {
        final String data = await multipart.join();
        final field = new StringFormField(name, data, contentType: contentType);
        ret[field.name] = field;
      } else if (multipart.isText) {
        final field = new TextFileFormField(name, multipart as Stream<String>,
            contentType: contentType, filename: fn);
        ret[field.name] = field;
      } else {
        final field = new BinaryFileFormField(
            name, multipart as Stream<List<int>>,
            contentType: contentType, filename: fn);
        ret[field.name] = field;
      }
    }

    return ret;
  }
}
