part of jaguar.mux;

/// Constructs a [RouteBuilder] for GET method requests
RouteBuilder get(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder post(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder put(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder delete(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder options(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder html(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder json(String path, RouteFunc handler,
        {List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
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
RouteBuilder getJson(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder postJson(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder putJson(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
RouteBuilder deleteJson(String path, RouteFunc handler,
        {Map<String, String> pathRegEx,
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
  final String path;

  /// Methods handled by the route
  final List<String> methods;

  /// Default status code for the route response
  final int statusCode;

  /// Default mime-type for route response
  final String mimeType;

  /// Default charset for route response
  final String charset;

  /// Default headers for route response
  final Map<String, String> headers;

  /// Regex for the route path
  final Map<String, String> pathRegEx;

  final ResponseProcessor responseProcessor;

  /// The route handler function
  final RouteFunc handler;

  /// Constructs a [RouteBuilder]
  RouteBuilder(this.path, this.handler,
      {this.methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor});

  /// Constructs a [RouteBuilder] for GET method requests
  RouteBuilder.get(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor})
      : methods = ['GET'];

  /// Constructs a [RouteBuilder] for POST method requests
  RouteBuilder.post(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor})
      : methods = ['POST'];

  /// Constructs a [RouteBuilder] for PUT method requests
  RouteBuilder.put(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor})
      : methods = ['PUT'];

  /// Constructs a [RouteBuilder] for DELETE method requests
  RouteBuilder.delete(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor})
      : methods = ['DELETE'];

  /// Constructs a [RouteBuilder] for PATCH method requests
  RouteBuilder.patch(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor})
      : methods = ['PATCH'];

  /// Constructs a [RouteBuilder] for OPTIONS method requests
  RouteBuilder.options(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.mimeType,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor})
      : methods = ['OPTIONS'];

  /// Constructs a [RouteBuilder] for HTML requests
  RouteBuilder.html(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor})
      : methods = ['GET'],
        mimeType = MimeType.html;

  /// Constructs a [RouteBuilder] for JSON requests
  RouteBuilder.json(this.path, this.handler,
      {this.methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor})
      : mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with GET method
  RouteBuilder.getJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor})
      : methods = ['GET'],
        mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with POST method
  RouteBuilder.postJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor})
      : methods = ['POST'],
        mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with PUT method
  RouteBuilder.putJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor})
      : methods = ['PUT'],
        mimeType = MimeType.json;

  /// Constructs a [RouteBuilder] for JSON requests with DELETE method
  RouteBuilder.deleteJson(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode: 200,
      this.charset: kDefaultCharset,
      this.headers,
      this.responseProcessor: jsonResponseProcessor})
      : methods = ['DELETE'],
        mimeType = MimeType.json;

  /// Interceptors wrapped around the [handler]
  final _interceptors = <InterceptorCreator>[];

  /// Exception handlers for the [handler]
  final _exceptionHandlers = <ExceptionHandler>[];

  /// Interceptors
  UnmodifiableListView<InterceptorCreator> get interceptors =>
      new UnmodifiableListView<InterceptorCreator>(_interceptors);

  /// Exception handlers
  UnmodifiableListView<ExceptionHandler> get exceptionHandlers =>
      new UnmodifiableListView<ExceptionHandler>(_exceptionHandlers);

  /// Wraps a single [interceptor] around the [handler]
  RouteBuilder wrap(InterceptorCreator interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  /// Wraps all of the given [interceptors] around the [handler]
  RouteBuilder wrapAll(Iterable<InterceptorCreator> interceptors) {
    this._interceptors.addAll(interceptors);
    return this;
  }

  /// Registers the given [exceptionHandler] for the [handler]
  RouteBuilder onException(ExceptionHandler exceptionHandler) {
    _exceptionHandlers.add(exceptionHandler);
    return this;
  }

  /// Registers all of the given [exceptionHandler] for the [handler]
  RouteBuilder onExceptionAll(Iterable<ExceptionHandler> exceptionHandlers) {
    _exceptionHandlers.addAll(exceptionHandlers);
    return this;
  }

  /// Clones this [RouteBuilder] with the [newPath] as [path]
  RouteBuilder cloneWithPath(String newPath) =>
      new RouteBuilder(newPath, handler,
          methods: methods,
          pathRegEx: this.pathRegEx,
          statusCode: this.statusCode,
          mimeType: this.mimeType,
          charset: this.charset,
          headers: this.headers,
          responseProcessor: responseProcessor);

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
