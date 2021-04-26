part of 'response.dart';

/// [Response] that writes the bytes provided in [body] to the response.
class ByteResponse extends Response<List<int>> {
  ByteResponse({
    List<int>? body,
    int statusCode = 200,
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

  @override
  void writeResponse(HttpResponse resp) {
    writeAllButBody(resp);
    if (body != null) {
      resp.add(body!);
    }
  }
}
