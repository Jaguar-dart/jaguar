part of jaguar.src.serve;

/// Implements the handler for [Jaguar]
abstract class _Handler {
  SessionManager get sessionManager;

  List<InterceptorCreator> get _interceptorCreators;

  String get basePath;

  Logger get log;

  List<RequestHandler> get _builtHandlers;

  DebugStream get debugStream;

  ErrorWriter get errorWriter;

  Future _handleRequest(HttpRequest request) async {
    final start = new DateTime.now();
    log.info("Req => Method: ${request.method} Url: ${request.uri}");

    final ctx = new Context(new Request(request, log), sessionManager);
    ctx.addInterceptors(_interceptorCreators);

    Response response;
    try {
      // Try to find a matching route and invoke it.
      for (RequestHandler requestHandler in _builtHandlers) {
        response = await requestHandler.handleRequest(ctx, prefix: basePath);
        if (response is Response) {
          break;
        }
      }

      // Update session, if required.
      if (response is Response) {
        if (ctx.sessionNeedsUpdate) await sessionManager.write(ctx, response);
      }
    } catch (e, stack) {
      if (e is Response) {
        // If [Response] object was thrown, write it!
        response = e;
      } else if (e is ResponseError) {
        final Response resp = e.response(ctx);
        response = resp;
      } else {
        log.severe("ReqErr => Method: ${request.method} Url: ${request
            .uri} E: $e Stack: $stack");
        response = errorWriter.make500(ctx, e, stack);
      }
    }

    // If no response, write 404 error.
    if (response is Response) {
      debugStream?._add(new DebugInfo.make(ctx, response, start));
    } else {
      response = errorWriter.make404(ctx);
    }

    // Write response
    try {
      await response.writeResponse(request.response);
    } catch (_) {}

    return request.response.close();
  }
}
