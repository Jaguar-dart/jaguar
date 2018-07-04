import 'dart:async';
import 'dart:io';
import 'response.dart';
import 'package:jaguar/src/http/http.dart';

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

  factory StreamResponse.fromFile(File file,
          {statusCode: 200,
          Map<String, dynamic> headers,
          String mimeType,
          String charset}) =>
      StreamResponse(
        file.openRead(),
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType = MimeType.ofFile(file),
        charset: charset,
      );

  static Future<StreamResponse> fromPath(String path,
      {int statusCode: 200,
      Map<String, dynamic> headers,
      String mimeType,
      String charset}) async {
    final file = new File(path);
    if (!await file.exists()) {
      // TODO
      throw new Exception();
    }
    return new StreamResponse.fromFile(file,
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType,
        charset: charset);
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
