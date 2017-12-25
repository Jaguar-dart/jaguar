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
      Map<String, String> headers}) {
    final route = new RouteBuilder(path, handler,
        pathRegEx: pathRegEx,
        methods: methods,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  RouteBuilder get(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.get(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  RouteBuilder post(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.post(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  RouteBuilder put(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.put(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  RouteBuilder delete(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.delete(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with PATCH method to be served
  RouteBuilder patch(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.patch(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with OPTIONS method to be served
  RouteBuilder options(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String mimeType: kDefaultMimeType,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.options(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        mimeType: mimeType,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  RouteBuilder html(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.html(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route to be served
  RouteBuilder json(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      List<String> methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.json(path, handler,
        pathRegEx: pathRegEx,
        methods: methods,
        statusCode: statusCode,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with GET method to be served
  RouteBuilder getJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.getJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with POST method to be served
  RouteBuilder postJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.postJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with PUT method to be served
  RouteBuilder putJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.putJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }

  /// Adds a route with DELETE method to be served
  RouteBuilder deleteJson(String path, RouteFunc handler,
      {Map<String, String> pathRegEx,
      int statusCode: 200,
      String charset: kDefaultCharset,
      Map<String, String> headers}) {
    final route = new RouteBuilder.deleteJson(path, handler,
        pathRegEx: pathRegEx,
        statusCode: statusCode,
        charset: charset,
        headers: headers);
    return addRoute(route);
  }
}
