part of jaguar.mux;

abstract class Muxable {
  /// Adds a route to the muxer
  Route addRoute(Route route);

  /// Adds a route to be served
  Route route(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route(path, handler,
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
  Route get(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.get(path, handler,
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
  Route post(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.post(path, handler,
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
  Route put(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.put(path, handler,
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
  Route delete(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.delete(path, handler,
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
  Route patch(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.patch(path, handler,
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
  Route options(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.options(path, handler,
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
      {List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    for (String path in handlers.keys) {
      Route rb;
      dynamic v = handlers[path];
      if (v is RouteHandler) {
        rb = addRoute(new Route(path, v));
        rb.before.addAll(before);
        rb.after.addAll(after);
        rb.onException.addAll(onException);
      } else if (v is Route) {
        rb = addRoute(v);
        rb.before.addAll(before);
        rb.after.addAll(after);
        rb.onException.addAll(onException);
      } else if (v is Iterable<RouteHandler>) {
        for (RouteHandler v1 in v) {
          rb = addRoute(new Route(path, v1));
          rb.before.addAll(before);
          rb.after.addAll(after);
          rb.onException.addAll(onException);
        }
      } else if (v is Iterable<Route>) {
        for (Route v1 in v) {
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
  Route html(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.html(path, handler,
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
  Route json(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.json(path, handler,
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
  Route getJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.getJson(path, handler,
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
  Route postJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.postJson(path, handler,
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
  Route putJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.putJson(path, handler,
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
  Route deleteJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    final route = new Route.deleteJson(path, handler,
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
  Route ws(String path, WsTransformer handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    return addRoute(new Route.get(path, socketHandler(handler),
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException));
  }

  /// Example:
  ///     server.wsJson('/ws', (Map data) => {'data': data});
  Route wsJson(String path, WsTransformer handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    return addRoute(new Route.get(path, socketHandler(handler),
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException));
  }

  /// Serves requests for static files at [path] from [directory]
  ///
  /// [stripPrefix] parameter determines if the matched part of the path shall be
  /// discarded while locating the target file.
  ///
  /// When [stripPrefix] is true, the behaviour is similar to 'alias' in Nginx.
  ///
  /// With [path] '/static/*', the target file will be located inside [directory]
  /// in the following way:
  ///
  /// /static/html/index.html -> html/index.html
  ///
  /// When [stripPrefix] is false, the behavior is similar to 'root' in Nginx.
  ///
  /// With [path] '/static/*', the target file will be located inside [directory]
  /// in the following way:
  ///
  /// /static/html/index.html -> static/html/index.html
  ///
  /// Example:
  ///    final server = new Jaguar();
  ///    server.staticFiles('/static/*', 'static');
  ///    await server.serve();
  void staticFiles(String path, directory,
      {Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType: kDefaultMimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        bool stripPrefix: true}) {
    if (directory is String) {
      directory = new Directory(directory);
    }

    final Directory dir = directory;
    if (!dir.existsSync())
      throw new Exception('Directory ${dir.path} does not exist!');

    List<String> parts = splitPathToSegments(path);

    int len = parts.length;
    if (parts.last == '*') len--;

    this.get(path, (Context ctx) async {
      final List<String> paths = stripPrefix
          ? ctx.uri.pathSegments.sublist(len)
          : ctx.uri.pathSegments;
      String path = p.join(dir.path, p.joinAll(paths));
      File file = new File(path);

      if (!await file.exists()) {
        final Directory fileDir = new Directory(path);
        if (!await fileDir.exists()) return null;

        path = p.join(path, 'index.html');
        file = new File(path);

        if (!await file.exists()) {
          // TODO render directory listing
          return null;
        }
      }
      return new Response<Stream<List<int>>>(await file.openRead(),
          mimeType: MimeType.ofFile(file));
    },
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: kDefaultCharset,
        headers: headers);
  }

  /// Serves requests at [path] with content of [file]
  ///
  /// Example:
  ///    final server = new Jaguar();
  ///    server.staticFile('/hello', p.join('static', 'hello.txt'));
  ///    await server.serve();
  void staticFile(String path, file,
      {Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers}) {
    if (file is String) {
      file = new File(file);
    }

    final File f = file;
    this.get(path, (_) => f.openRead(),
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType ?? MimeType.ofFile(f) ?? kDefaultMimeType,
        charset: kDefaultCharset,
        headers: headers);
  }
}
