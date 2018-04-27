part of jaguar.mux;

/// Constructs a [RouteBuilder] for GET method requests
RouteBuilder get(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor}) =>
    new RouteBuilder.get(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for POST method requests
RouteBuilder post(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor}) =>
    new RouteBuilder.post(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for PUT method requests
RouteBuilder put(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor}) =>
    new RouteBuilder.put(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for DELETE method requests
RouteBuilder delete(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor}) =>
    new RouteBuilder.delete(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for OPTIONS method requests
RouteBuilder options(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String mimeType,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor}) =>
    new RouteBuilder.options(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for HTML requests
RouteBuilder html(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor}) =>
    new RouteBuilder.html(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for JSON requests
RouteBuilder json(RouteHandler handler,
        {String path,
        List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor}) =>
    new RouteBuilder.json(path, handler,
        methods: methods,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for JSON requests with GET method
RouteBuilder getJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor}) =>
    new RouteBuilder.getJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for JSON requests with POST method
RouteBuilder postJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor}) =>
    new RouteBuilder.postJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for JSON requests with PUT method
RouteBuilder putJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor}) =>
    new RouteBuilder.putJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Constructs a [RouteBuilder] for JSON requests with DELETE method
RouteBuilder deleteJson(RouteHandler handler,
        {String path,
        Map<String, String> pathRegEx,
        int statusCode: 200,
        String charset: kDefaultCharset,
        Map<String, String> headers,
        ResponseProcessor responseProcessor: jsonResponseProcessor}) =>
    new RouteBuilder.deleteJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers,
        responseProcessor: responseProcessor);

/// Helps builds a route handler with its interceptors and exception handlers
class RouteBuilder {
  /// Path of the route
  String path;

  /// Methods handled by the route
  List<String> methods;

  /// Default status code for the route response
  int statusCode;

  /// Default mime-type for route response
  String mimeType;

  /// Default charset for route response
  String charset;

  /// Default headers for route response
  Map<String, String> headers;

  /// Regex for the route path
  Map<String, String> pathRegEx;

  ResponseProcessor responseProcessor;

  /// The route handler function
  RouteHandler handler;

  final List<RouteFunc> before;

  final List<RouteFunc> after;

  final List<ExceptionHandler> onException;

  /// Constructs a [RouteBuilder]
  RouteBuilder(this.path, this.handler,
      {this.methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []});

  /// Constructs a [RouteBuilder] for GET method requests
  RouteBuilder.get(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['GET'];

  /// Constructs a [RouteBuilder] for POST method requests
  RouteBuilder.post(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['POST'];

  /// Constructs a [RouteBuilder] for PUT method requests
  RouteBuilder.put(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['PUT'];

  /// Constructs a [RouteBuilder] for DELETE method requests
  RouteBuilder.delete(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['DELETE'];

  /// Constructs a [RouteBuilder] for PATCH method requests
  RouteBuilder.patch(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['PATCH'];

  /// Constructs a [RouteBuilder] for OPTIONS method requests
  RouteBuilder.options(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['OPTIONS'];

  /// Constructs a [RouteBuilder] for HTML requests
  RouteBuilder.html(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['GET'],
        mimeType = MimeType.html;

  /// Constructs a [RouteBuilder] for JSON requests
  RouteBuilder.json(this.path, this.handler,
      {this.methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with GET method
  RouteBuilder.getJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['GET'],
        mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with POST method
  RouteBuilder.postJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['POST'],
        mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with PUT method
  RouteBuilder.putJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['PUT'],
        mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with DELETE method
  RouteBuilder.deleteJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor,
      this.after: const [],
      this.before: const [],
      this.onException: const []})
      : methods = ['DELETE'],
        mimeType = MimeType.json;

  /// Clones this [RouteBuilder] with the [newPath] as [path]
  RouteBuilder cloneWithPath(String newPath) =>
      new RouteBuilder(newPath, handler,
          methods: methods,
          pathRegEx: this.pathRegEx,
          statusCode: this.statusCode,
          mimeType: this.mimeType,
          charset: this.charset,
          headers: this.headers,
          responseProcessor: responseProcessor,
          before: before,
          after: after,
          onException: onException);

  Route get routeInfo => new Route(
      path: path,
      methods: methods,
      statusCode: statusCode,
      mimeType: mimeType,
      charset: charset,
      headers: headers,
      pathRegEx: pathRegEx,
      responseProcessor: responseProcessor);
}
