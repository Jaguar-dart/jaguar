part of 'response.dart';

/// [Response] that writes the stream of bytes provided in [body] to the
/// response.
class StreamResponse extends Response<Stream<List<int>>> {
  StreamResponse({
    Stream<List<int>>? body,
    statusCode = 200,
    Map<String, dynamic>? headers,
    String? mimeType,
    String? charset,
    List<Cookie>? cookies,
  }) : super._make(
            body: body,
            statusCode: statusCode,
            headers: headers,
            mimeType: mimeType,
            charset: charset,
            cookies: cookies);

  /// [Response] that writes the contents of [file] to the response.
  factory StreamResponse.fromFile(
    File file, {
    statusCode = 200,
    Map<String, dynamic>? headers,
    String? mimeType,
    String? charset,
    List<Cookie>? cookies,
  }) =>
      StreamResponse(
        body: file.openRead(),
        statusCode: statusCode,
        headers: headers,
        mimeType: mimeType ?? MimeTypes.ofFile(file),
        charset: charset,
        cookies: cookies,
      );

  /// [Response] that writes the contents of file at [path] to the response.
  static Future<StreamResponse> fromPath(
    String path, {
    int statusCode = 200,
    Map<String, dynamic>? headers,
    String? mimeType,
    String? charset,
    List<Cookie>? cookies,
  }) async {
    final file = File(path);
    if (!await file.exists()) throw new Exception();
    return StreamResponse.fromFile(
      file,
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType ?? MimeTypes.ofFile(file),
      charset: charset,
      cookies: cookies,
    );
  }

  /// [Response] that writes the [strings] to the response.
  factory StreamResponse.fromStrings(
    Stream<String> strings, {
    statusCode = 200,
    Map<String, dynamic>? headers,
    String? mimeType,
    String? charset,
    cnv.Encoding encoding = cnv.utf8,
    List<Cookie>? cookies,
  }) {
    return StreamResponse(
      body: strings.transform(encoding.encoder),
      statusCode: statusCode,
      headers: headers,
      mimeType: mimeType,
      charset: charset,
      cookies: cookies,
    );
  }

  /// Writes body of the HTTP response from [body] property
  ///
  /// Different [ValueTypes] are differently when they are written
  /// to the response.
  Future<void> writeResponse(HttpResponse resp) async {
    writeAllButBody(resp);
    if (body != null) {
      await resp.addStream(body!);
    }
  }
}
