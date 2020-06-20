library jaguar.src.serve.error_writer;

import 'dart:async';
import 'dart:io';
import 'package:stack_trace/stack_trace.dart';
import 'package:jaguar/jaguar.dart';

part 'template_404.dart';
part 'template_500.dart';

/// Error writer interface
///
/// Error writer is used by [Jaguar] server to write 404 and 500 errors
abstract class ErrorWriter {
  /// Makes [Response] for 404 error
  FutureOr<Response> make404(Context ctx);

  /// Makes [Response] for 500 error
  FutureOr<Response> make500(Context ctx, Object error, [StackTrace stack]);
}

class DefaultErrorWriter implements ErrorWriter {
  /// Makes [Response] for 404 error
  ///
  /// Respects 'accept' request header and returns corresponding [Response]
  Response make404(Context ctx) {
    final String accept = ctx.req.headers.value(HttpHeaders.acceptHeader) ?? '';
    final List<String> acceptList = accept.split(',');

    if (acceptList.contains('text/html')) {
      return Response(_write404Html(ctx),
          statusCode: HttpStatus.notFound, mimeType: MimeTypes.html);
    } else if (acceptList.contains('application/json') ||
        acceptList.contains('text/json')) {
      return Response.json({
        'Path': ctx.path,
        'Method': ctx.method,
        'Message': 'Not found!',
      }, statusCode: HttpStatus.notFound);
    } /* TODO else if (acceptList.contains('application/xml')) {
      return Response.xml({
        'Path': ctx.path,
        'Method': ctx.method,
        'Message': 'Not found!',
      }, statusCode: HttpStatus.NOT_FOUND);
      return;
    } */
    else {
      return Response(_write404Html(ctx), statusCode: HttpStatus.notFound)
        ..headers.contentType = ContentType.html;
    }
  }

  /// Makes [Response] for 500 error
  ///
  /// Respects 'accept' request header and returns corresponding [Response]
  Response make500(Context ctx, Object error, [StackTrace stack]) {
    final String accept = ctx.req.headers.value(HttpHeaders.acceptHeader) ?? '';
    final List<String> acceptList = accept.split(',');

    if (acceptList.contains('text/html')) {
      return Response(_write500Html(ctx, error, stack),
          statusCode: HttpStatus.notFound, mimeType: MimeTypes.html);
    } else if (acceptList.contains('application/json') ||
        acceptList.contains('text/json')) {
      final data = <String, dynamic>{
        'error': error.toString(),
      };
      if (stack != null)
        data['stack'] =
            Trace.from(stack).frames.map((f) => f.toString()).toList();

      return Response.json(data, statusCode: 500);
    } /* TODO else if (acceptList.contains('application/xml')) {
      final data = <String, dynamic>{
        'error': error.toString(),
      };
      if (stack != null) data['stack'] = Trace.format(stack);

      return Response.xml(data, statusCode: 500);
    } */
    else {
      return Response(_write500Html(ctx, error, stack),
          statusCode: 500, mimeType: MimeTypes.html);
    }
  }
}
