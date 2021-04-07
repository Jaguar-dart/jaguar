part of jaguar.http.request;

/// Abstract class for fields on `multipart/form-data`
abstract class FormField<T> {
  /// Name of the field
  String get name;

  /// Value of the field
  T get value;

  /// content-type of the field
  ContentType? get contentType;
}

/// String field in the `multipart/form-data`
///
/// Contains `String` value
class StringFormField implements FormField<String> {
  /// Name of the field
  final String name;

  /// Value of the field
  final String value;

  /// content-type of the field
  final ContentType? contentType;

  StringFormField(this.name, this.value, {this.contentType});

  String toString() {
    return "StringFormField('$name', '$value', '$contentType')";
  }
}

abstract class FileFormField<T> implements FormField<T> {
  Future<File> writeTo(String path);
}

/// Text file field in the `multipart/form-data`
class TextFileFormField implements FileFormField<Stream<String>> {
  /// Name of the field
  final String name;

  /// Value of the field
  ///
  /// Returns a stream of text
  final Stream<String> value;

  /// content-type of the field
  final ContentType? contentType;

  /// File of the file field
  final String? filename;

  TextFileFormField(this.name, this.value, {this.contentType, this.filename});

  String toString() {
    return "FileFormField('$name', '$contentType', '$filename')";
  }

  /// Writes the contents of the file to file at [path]
  Future<File> writeTo(String path, {Encoding encoding = utf8}) async {
    final file = File(path);
    IOSink sink = file.openWrite(encoding: encoding);
    await for (String item in value) {
      sink.write(item);
    }
    await sink.flush();
    await sink.close();
    return file;
  }
}

class TextFileListFormField implements TextFileFormField {
  /// Name of the field
  String get name => values.first.name;

  /// Value of the field
  ///
  /// Returns a stream of text
  Stream<String> get value => values.first.value;

  /// content-type of the field
  ContentType? get contentType => values.first.contentType;

  String? get filename => values.first.filename;

  final List<TextFileFormField> values;

  TextFileListFormField(TextFileFormField first) : values = [first];

  TextFileListFormField.fromValues(List<TextFileFormField> values)
      : values = values;

  /// Writes the contents of the file to file at [path]
  Future<File> writeTo(String path, {Encoding encoding = utf8}) =>
      values.first.writeTo(path, encoding: encoding);
}

/// Binary file field in the `multipart/form-data`
class BinaryFileFormField implements FileFormField<Stream<List<int>>> {
  /// Name of the field
  final String name;

  /// Value of the field
  final Stream<List<int>> value;

  /// content-type of the field
  final ContentType? contentType;

  /// File of the file field
  final String? filename;

  BinaryFileFormField(this.name, this.value, {this.contentType, this.filename});

  String toString() {
    return "FileFormField('$name', '$contentType', '$filename')";
  }

  /// Writes the contents of the file to file at [path]
  Future<File> writeTo(String path) async {
    final file = File(path);
    IOSink sink = file.openWrite();
    await for (List<int> item in value) {
      sink.add(item);
    }
    await sink.flush();
    await sink.close();
    return file;
  }
}

class BinaryFileListFormField implements BinaryFileFormField {
  /// Name of the field
  String get name => values.first.name;

  /// Value of the field
  ///
  /// Returns a stream of text
  Stream<List<int>> get value => values.first.value;

  /// content-type of the field
  ContentType? get contentType => values.first.contentType;

  String? get filename => values.first.filename;

  final List<BinaryFileFormField> values;

  BinaryFileListFormField(BinaryFileFormField first) : values = [first];

  BinaryFileListFormField.fromValues(List<BinaryFileFormField> values)
      : values = values;

  /// Writes the contents of the file to file at [path]
  Future<File> writeTo(String path) => values.first.writeTo(path);
}
