import 'response.dart';
import 'dart:async';
import 'dart:io';

class Redirect extends Response<Uri> {
  Redirect(
    Uri value, {
    statusCode: HttpStatus.movedPermanently,
    Map<String, dynamic> headers,
  }) : super(value, statusCode: statusCode, headers: headers);

  factory Redirect.found(value,
          {Map<String, dynamic> headers,
          statusCode = HttpStatus.movedTemporarily}) =>
      Redirect(
        value,
        headers: headers,
        statusCode: statusCode,
      );

  factory Redirect.seeOther(value,
          {Map<String, dynamic> headers, statusCode = HttpStatus.seeOther}) =>
      Redirect(
        value,
        headers: headers,
        statusCode: statusCode,
      );

  factory Redirect.temporaryRedirect(value,
          {Map<String, dynamic> headers,
          statusCode = HttpStatus.temporaryRedirect}) =>
      Redirect(
        value,
        headers: headers,
        statusCode: statusCode,
      );

  factory Redirect.permanentRedirect(value,
          {Map<String, dynamic> headers, statusCode = 308}) =>
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
