part of jaguar.mux;

abstract class Muxable {
  /// Adds a route to the muxer
  RouteBuilder addRoute(RouteBuilder route);

  /// Adds a route to be served
  RouteBuilder route(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder(path, handler,
        methods: methods,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  RouteBuilder get(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.get(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  RouteBuilder post(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.post(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  RouteBuilder put(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.put(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  RouteBuilder delete(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.delete(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with PATCH method to be served
  RouteBuilder patch(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.patch(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with OPTIONS method to be served
  RouteBuilder options(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.options(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  void map(
      Map<
              String,
              /* RouteFunc | RouteBuilder | Iterable<RouteFunc> | Iterable<RouteBuilder> */ dynamic>
          handlers,
      {Iterable<RouteFunc> before: const [],
      Iterable<RouteFunc> after: const [],
      Iterable<ExceptionHandler> onException}) {
    for (String path in handlers.keys) {
      RouteBuilder rb;
      dynamic v = handlers[path];
      if (v is RouteHandler) {
        rb = addRoute(new RouteBuilder(path, v));
        rb.before.addAll(before);
        rb.after.addAll(after);
        rb.onException.addAll(onException);
      } else if (v is RouteBuilder) {
        rb = addRoute(v);
        rb.before.addAll(before);
        rb.after.addAll(after);
        rb.onException.addAll(onException);
      } else if (v is Iterable<RouteHandler>) {
        for (RouteHandler v1 in v) {
          rb = addRoute(new RouteBuilder(path, v1));
          rb.before.addAll(before);
          rb.after.addAll(after);
          rb.onException.addAll(onException);
        }
      } else if (v is Iterable<RouteBuilder>) {
        for (RouteBuilder v1 in v) {
          rb = addRoute(v1);
          rb.before.addAll(before);
          rb.after.addAll(after);
          rb.onException.addAll(onException);
        }
      } else {
        throw new UnsupportedError('Handler not supported!');
      }
    }
  }

  /// Adds a route with GET method to be served
  RouteBuilder html(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.html(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route to be served
  RouteBuilder json(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.json(path, handler,
        pathRegEx: pathRegEx,
        methods: methods,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  RouteBuilder getJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.getJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  RouteBuilder postJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.postJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  RouteBuilder putJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.putJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  RouteBuilder deleteJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    final route = new RouteBuilder.deleteJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Example:
  ///     server.ws('/ws', (String data) => int.parse(data) + 1);
  RouteBuilder ws(String path, WsTransformer handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    return addRoute(new RouteBuilder.get(path, socketHandler(handler),
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException));
  }

  /// Example:
  ///     server.wsJson('/ws', (Map data) => {'data': data});
  RouteBuilder wsJson(String path, WsTransformer handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteFunc> before,
      List<RouteFunc> after,
      List<ExceptionHandler> onException}) {
    return addRoute(new RouteBuilder.get(path, socketHandler(handler),
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException));
  }
}
