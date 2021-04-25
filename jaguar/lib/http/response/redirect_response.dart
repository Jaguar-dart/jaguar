part of 'response.dart';

/// [Response] that redirects to the URI specified by [body]
class Redirect extends Response<Uri> {
  Redirect(
    Uri body, {
    statusCode = HttpStatus.movedPermanently,
    Map<String, dynamic>? headers,
    List<Cookie>? cookies,
  }) : super._make(
          body: body,
          statusCode: statusCode,
          headers: headers,
          cookies: cookies,
        );

  /// Performs 'moved temporarily' (status code: 302) redirect
  factory Redirect.found(
    body, {
    Map<String, dynamic>? headers,
    statusCode = HttpStatus.movedTemporarily,
    List<Cookie>? cookies,
  }) =>
      Redirect(
        body,
        headers: headers,
        statusCode: statusCode,
        cookies: cookies,
      );

  /// Performs 'see other' (status code: 303) redirect
  factory Redirect.seeOther(
    body, {
    Map<String, dynamic>? headers,
    statusCode = HttpStatus.seeOther,
    List<Cookie>? cookies,
  }) =>
      Redirect(
        body,
        headers: headers,
        statusCode: statusCode,
        cookies: cookies,
      );

  /// Performs 'temporary redirect' (status code: 307) redirect
  factory Redirect.temporaryRedirect(
    body, {
    Map<String, dynamic>? headers,
    statusCode = HttpStatus.temporaryRedirect,
    List<Cookie>? cookies,
  }) =>
      Redirect(
        body,
        headers: headers,
        statusCode: statusCode,
        cookies: cookies,
      );

  /// Performs 'permanent redirect' (status code: 308) redirect
  factory Redirect.permanentRedirect(
    body, {
    Map<String, dynamic>? headers,
    statusCode = 308,
    List<Cookie>? cookies,
  }) =>
      Redirect(
        body,
        headers: headers,
        statusCode: statusCode,
        cookies: cookies,
      );

  @override
  Future<void> writeResponse(HttpResponse resp) async {
    writeAllButBody(resp);
    if (body != null) {
      await resp.redirect(body!, status: statusCode);
    } else {
      // TODO should this be allowed?
    }
  }
}
