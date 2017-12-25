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
    final ctx = new Context(new Request(request, sessionManager, log));
    ctx.addInterceptors(_interceptorCreators);

    Response response;
    try {
      for (RequestHandler requestHandler in _builtHandlers) {
        response = await requestHandler.handleRequest(ctx, prefix: basePath);
        if (response is Response) {
          break;
        }
      }

      if (response is Response) {
        if (ctx.req.sessionNeedsUpdate)
          await sessionManager.write(ctx.req, response);
      }
    } catch (e, stack) {
      if (e is Response) {
        await e.writeResponse(request.response);
        debugStream?._add(new DebugInfo.make(ctx, e, start));
      } else if (e is ResponseError) {
        final Response resp = e.response(ctx);
        await resp.writeResponse(request.response);
        debugStream?._add(new DebugInfo.make(ctx, resp, start));
      } else {
        log.severe("ReqErr => Method: ${request.method} Url: ${request
            .uri} E: $e Stack: $stack");

        final Response resp = errorWriter.make500(ctx, e, stack);
        await resp.writeResponse(request.response);
        debugStream?._add(new DebugInfo.make(ctx, resp, start));
      }
      return request.response.close();
    }

    if (response is Response) {
      debugStream?._add(new DebugInfo.make(ctx, response, start));
    } else {
      response = errorWriter.make404(ctx);
    }

    try {
      await response.writeResponse(request.response);
    } catch (_) {}

    return request.response.close();
  }
}
