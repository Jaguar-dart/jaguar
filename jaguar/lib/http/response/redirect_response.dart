import 'response.dart';
import 'dart:async';
import 'dart:io';

/// [Response] that redirects to the URI specified by [value]
class Redirect extends Response<Uri> {
  Redirect(
    Uri value, {
    statusCode = HttpStatus.movedPermanently,
    Map<String, dynamic>? headers,
  }) : super(value, statusCode: statusCode, headers: headers);

  /// Performs 'moved temporarily' (status code: 302) redirect
  factory Redirect.found(value,
          {Map<String, dynamic>? headers,
          statusCode = HttpStatus.movedTemporarily}) =>
      Redirect(
        value,
        headers: headers,
        statusCode: statusCode,
      );

  /// Performs 'see other' (status code: 303) redirect
  factory Redirect.seeOther(
    value, {
    Map<String, dynamic>? headers,
    statusCode = HttpStatus.seeOther,
  }) =>
      Redirect(
        value,
        headers: headers,
        statusCode: statusCode,
      );

  /// Performs 'temporary redirect' (status code: 307) redirect
  factory Redirect.temporaryRedirect(value,
          {Map<String, dynamic>? headers,
          statusCode = HttpStatus.temporaryRedirect}) =>
      Redirect(
        value,
        headers: headers,
        statusCode: statusCode,
      );

  /// Performs 'permanent redirect' (status code: 308) redirect
  factory Redirect.permanentRedirect(
    value, {
    Map<String, dynamic>? headers,
    statusCode = 308,
  }) =>
      Redirect(
        value,
        headers: headers,
        statusCode: statusCode,
      );

  @override
  Future<void> writeResponse(HttpResponse resp) async {
    writeAllButBody(resp);
    await resp.redirect(value, status: statusCode);
  }
}
