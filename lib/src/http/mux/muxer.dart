part of jaguar.mux;

abstract class Muxable {
  /// Adds a route to the muxer
  RouteBuilder addRoute(RouteBuilder route);

  /// Adds a route to be served
  RouteBuilder route(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder(path, handler,
        methods: methods,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  RouteBuilder get(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder.get(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  RouteBuilder post(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder.post(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  RouteBuilder put(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder.put(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  RouteBuilder delete(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder.delete(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with PATCH method to be served
  RouteBuilder patch(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder.patch(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with OPTIONS method to be served
  RouteBuilder options(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder.options(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  void map(
      Map<
              String,
              /* RouteFunc | RouteBuilder | Iterable<RouteFunc> | Iterable<RouteBuilder> */ dynamic>
          handlers,
      {/* InterceptorCreator | Iterable<InterceptorCreator> */ intercept,
      /* ExceptionHandler | List<ExceptionHandler> */ onException}) {
    for (String path in handlers.keys) {
      RouteBuilder rb;
      dynamic v = handlers[path];
      if (v is RouteFunc) {
        rb = addRoute(new RouteBuilder(path, v));
        if (intercept is InterceptorCreator) {
          rb.wrap(intercept);
        } else if (intercept is Iterable<InterceptorCreator>) {
          rb.wrapAll(intercept);
        }
        if (onException is ExceptionHandler) {
          rb.onException(onException);
        } else if (onException is Iterable<ExceptionHandler>) {
          rb.onExceptionAll(onException);
        }
      } else if (v is RouteBuilder) {
        rb = addRoute(v);
        if (intercept is InterceptorCreator) {
          rb.wrap(intercept);
        } else if (intercept is Iterable<InterceptorCreator>) {
          rb.wrapAll(intercept);
        }
        if (onException is ExceptionHandler) {
          rb.onException(onException);
        } else if (onException is Iterable<ExceptionHandler>) {
          rb.onExceptionAll(onException);
        }
      } else if (v is Iterable<RouteFunc>) {
        for (RouteFunc v1 in v) {
          rb = addRoute(new RouteBuilder(path, v1));
          if (intercept is InterceptorCreator) {
            rb.wrap(intercept);
          } else if (intercept is Iterable<InterceptorCreator>) {
            rb.wrapAll(intercept);
          }
          if (onException is ExceptionHandler) {
            rb.onException(onException);
          } else if (onException is Iterable<ExceptionHandler>) {
            rb.onExceptionAll(onException);
          }
        }
      } else if (v is Iterable<RouteBuilder>) {
        for (RouteBuilder v1 in v) {
          rb = addRoute(v1);
          if (intercept is InterceptorCreator) {
            rb.wrap(intercept);
          } else if (intercept is Iterable<InterceptorCreator>) {
            rb.wrapAll(intercept);
          }
          if (onException is ExceptionHandler) {
            rb.onException(onException);
          } else if (onException is Iterable<ExceptionHandler>) {
            rb.onExceptionAll(onException);
          }
        }
      } else {
        throw new UnsupportedError('Handler not supported!');
      }
    }
  }

  /// Adds a route with GET method to be served
  RouteBuilder html(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor}) {
    final route = new RouteBuilder.html(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route to be served
  RouteBuilder json(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor}) {
    final route = new RouteBuilder.json(path, handler,
        pathRegEx: pathRegEx,
        methods: methods,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  RouteBuilder getJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor}) {
    final route = new RouteBuilder.getJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  RouteBuilder postJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor}) {
    final route = new RouteBuilder.postJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  RouteBuilder putJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor}) {
    final route = new RouteBuilder.putJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  RouteBuilder deleteJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor}) {
    final route = new RouteBuilder.deleteJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);
    return addRoute(route);
  }
}
