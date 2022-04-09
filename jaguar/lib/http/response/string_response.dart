part of 'response.dart';

/// [Response] that writes the bytes provided in [body] to the response.
class StringResponse extends Response<String> {
  StringResponse({
    dynamic body,
    int statusCode = 200,
    Map<String, dynamic>? headers,
    String? mimeType,
    String? charset,
    List<Cookie>? cookies,
  }) : super._make(
          body: body?.toString(),
          statusCode: statusCode,
          headers: headers,
          mimeType: mimeType,
          charset: charset,
          cookies: cookies,
        );

  factory StringResponse.cloneFrom(Response response,
      {dynamic body, int? statusCode, String? mimeType, String? charset}) {
    return StringResponse(
      body: body,
      statusCode: statusCode ?? response.statusCode,
      mimeType: mimeType,
      charset: charset,
      headers: response.headers.headers,
      cookies: response.cookies,
    );
  }

  @override
  void writeResponse(HttpResponse resp) {
    writeAllButBody(resp);
    if (body != null) {
      resp.write(body!);
    }
  }
}
