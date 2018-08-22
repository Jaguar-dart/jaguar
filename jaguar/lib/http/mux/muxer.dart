part of jaguar.mux;

abstract class Muxable {
  /// Adds a route to the muxer
  Route addRoute(Route route);

  /// Adds a route to be served
  Route route(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route(path, handler,
        methods: methods,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  Route get(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.get(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  Route post(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.post(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  Route put(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.put(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  Route delete(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.delete(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with PATCH method to be served
  Route patch(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.patch(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with OPTIONS method to be served
  Route options(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.options(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  void map(
      /* RouteFunc | RouteBuilder | Iterable<RouteFunc> | Iterable<RouteBuilder> */
      Map<String, dynamic> handlers,
      {List<RouteInterceptor> before: const [],
      List<RouteInterceptor> after: const [],
      List<ExceptionHandler> onException: const []}) {
    for (String path in handlers.keys) {
      Route rb;
      dynamic v = handlers[path];
      if (v is RouteHandler) {
        rb = addRoute(Route(path, v));
        rb._before.addAll(before);
        rb._after.addAll(after);
        rb._onException.addAll(onException);
      } else if (v is Route) {
        rb = addRoute(v);
        rb._before.addAll(before);
        rb._after.addAll(after);
        rb._onException.addAll(onException);
      } else if (v is Iterable<RouteHandler>) {
        for (RouteHandler v1 in v) {
          rb = addRoute(Route(path, v1));
          rb._before.addAll(before);
          rb._after.addAll(after);
          rb._onException.addAll(onException);
        }
      } else if (v is Iterable<Route>) {
        for (Route v1 in v) {
          rb = addRoute(v1);
          rb._before.addAll(before);
          rb._after.addAll(after);
          rb._onException.addAll(onException);
        }
      } else {
        throw UnsupportedError('Handler not supported!');
      }
    }
  }

  /// Adds a route with GET method to be served
  Route html(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: htmlResponseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.html(path, handler,
        pathRegEx: pathRegEx,
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
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.json(path, handler,
        pathRegEx: pathRegEx,
        methods: methods,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  Route getJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.getJson(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  Route postJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.postJson(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  Route putJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.putJson(path, handler,
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor,
        before: before,
        after: after,
        onException: onException);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  Route deleteJson(String path, RouteHandler handler,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor: jsonResponseProcessor,
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    final route = Route.deleteJson(path, handler,
        pathRegEx: pathRegEx,
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
      List<RouteInterceptor> after,
      List<RouteInterceptor> before,
      List<ExceptionHandler> onException}) {
    return addRoute(Route.get(path, wsHandler(handler),
        pathRegEx: pathRegEx,
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
  ///    final server = Jaguar();
  ///    server.staticFiles('/static/*', 'static');
  ///    await server.serve();
  Route staticFiles(String path, directory,
      {Map<String, String> pathRegEx,
      ResponseProcessor responseProcessor,
      bool stripPrefix: true,
      Future<Response> directoryLister(Directory directory)}) {
    if (directory is String) directory = Directory(directory);

    final Directory dir = directory;
    if (!dir.existsSync())
      throw Exception('Directory ${dir.path} does not exist!');

    Route route;
    int skipCount;
    route = this.get(path, (ctx) async {
      Iterable<String> segs = ctx.pathSegments;
      if (stripPrefix) segs = segs.skip(skipCount);

      String path = p.join(dir.path, p.joinAll(segs));
      var file = File(path);

      if (!await file.exists()) {
        final fileDir = Directory(path);

        if (!await fileDir.exists()) return null;

        path = p.join(path, 'index.html');
        file = File(path);

        if (!await file.exists()) {
          if (directoryLister != null) return directoryLister(fileDir);
          return null;
        }
      }

      return StreamResponse(await file.openRead(),
          mimeType: MimeTypes.ofFile(file));
    }, pathRegEx: pathRegEx, responseProcessor: responseProcessor);

    if (stripPrefix) {
      if (route.pathSegments.isNotEmpty)
        skipCount = route.pathSegments.length - 1;
    }
    return route;
  }

  /// Serves requests at [path] with content of [file]
  ///
  /// Example:
  ///    final server = Jaguar();
  ///    server.staticFile('/hello', p.join('static', 'hello.txt'));
  ///    await server.serve();
  Route staticFile(String path, file,
      {Map<String, String> pathRegEx, ResponseProcessor responseProcessor}) {
    if (file is String) file = File(file);

    final File f = file;
    return this.get(
        path,
        (_) async =>
            StreamResponse(await f.openRead(), mimeType: MimeTypes.ofFile(f)),
        pathRegEx: pathRegEx,
        responseProcessor: responseProcessor);
  }
}
