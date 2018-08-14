import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'response.dart';
import 'package:jaguar/http/http.dart';

/// [Response] that writes the stream of bytes provided in [value] to the
/// response.
class StreamResponse extends Response<Stream<List<int>>> {
  StreamResponse(Stream<List<int>> value,
      {statusCode: 200,
      Map<String, dynamic> headers,
      String mimeType,
      String charset})
      : super(value,
            statusCode: statusCode,
            headers: headers,
            mimeType: mimeType,
            charset: charset);

  /// [Response] that writes the contents of [file] to the response.
  factory StreamResponse.fromFile(File file,
          {statusCode: 200,
          Map<String, dynamic> headers,
          String mimeType,
          String charset}) =>
      StreamResponse(
        file.openRead(),
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType ?? MimeTypes.ofFile(file),
        charset: charset,
      );

  /// [Response] that writes the contents of file at [path] to the response.
  static Future<StreamResponse> fromPath(String path,
      {int statusCode: 200,
      Map<String, dynamic> headers,
      String mimeType,
      String charset}) async {
    final file = File(path);
    if (!await file.exists()) throw new Exception();
    return StreamResponse.fromFile(file,
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType ?? MimeTypes.ofFile(file),
        charset: charset);
  }

  /// [Response] that writes the [strings] to the response.
  factory StreamResponse.fromStrings(Stream<String> strings,
      {statusCode: 200,
      Map<String, dynamic> headers,
      String mimeType,
      String charset,
      Encoding encoding: utf8}) {
    return StreamResponse(
      strings.transform(encoding.encoder),
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType,
      charset: charset,
    );
  }

  /// Writes body of the HTTP response from [value] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  Future<void> writeResponse(HttpResponse resp) async {
    writeAllButBody(resp);
    await resp.addStream(value);
  }
}
