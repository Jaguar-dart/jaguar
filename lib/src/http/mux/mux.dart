library jaguar.mux;

import 'dart:collection';
import 'package:jaguar/jaguar.dart';

class RouteBuilder {
  final String path;

  final List<String> methods;

  /// Default status code for the route response
  final int statusCode;

  /// Default mime-type for route response
  final String mimeType;

  /// Default charset for route response
  final String charset;

  /// Default headers for route response
  final Map<String, String> headers;

  final Map<String, String> pathRegEx;

  final RouteFunc handler;

  RouteBuilder(this.path, this.handler,
      {this.methods: const <String>['GET', 'PUT', 'POST', 'DELETE'],
      this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.headers});

  RouteBuilder.get(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.headers})
      : methods = ['GET'];

  RouteBuilder.post(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.headers})
      : methods = ['POST'];

  RouteBuilder.put(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.headers})
      : methods = ['PUT'];

  RouteBuilder.delete(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.headers})
      : methods = ['DELETE'];

  RouteBuilder.patch(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.headers})
      : methods = ['PATCH'];

  RouteBuilder.options(this.path, this.handler,
      {this.pathRegEx,
      this.statusCode,
      this.mimeType,
      this.charset,
      this.headers})
      : methods = ['OPTIONS'];

  final _interceptors = <InterceptorCreator>[];

  final _exceptionHandlers = <ExceptionHandler>[];

  /// Interceptors
  UnmodifiableListView<InterceptorCreator> get interceptors =>
      new UnmodifiableListView<InterceptorCreator>(_interceptors);

  /// Exception handlers
  UnmodifiableListView<ExceptionHandler> get exceptionHandlers =>
      new UnmodifiableListView<ExceptionHandler>(_exceptionHandlers);

  RouteBuilder wrap(InterceptorCreator interceptor) {
    _interceptors.add(interceptor);
    return this;
  }

  RouteBuilder wrapAll(List<InterceptorCreator> interceptors) {
    this._interceptors.addAll(interceptors);
    return this;
  }

  RouteBuilder onException(ExceptionHandler exceptionHandler) {
    _exceptionHandlers.add(exceptionHandler);
    return this;
  }

  RouteBuilder onExceptionAll(List<ExceptionHandler> exceptions) {
    _exceptionHandlers.addAll(exceptions);
    return this;
  }

  RouteBuilder cloneWithPath(String newPath) =>
      new RouteBuilder(newPath, handler,
          methods: methods,
          pathRegEx: this.pathRegEx,
          statusCode: this.statusCode,
          mimeType: this.mimeType,
          charset: this.charset,
          headers: this.headers);
}

class GroupBuilder extends Object with Muxable {
  final Jaguar server;

  final String pathPrefix;

  final List<InterceptorCreator> _wrappers = [];

  List<InterceptorCreator> get wrappers => new List.unmodifiable(_wrappers);

  final exceptionHandlers = <ExceptionHandler>[];

  bool _wrapsFinalized = false;

  GroupBuilder(this.server, {String path: ''}) : pathPrefix = path ?? '';

  GroupBuilder wrap(InterceptorCreator interceptor) {
    if (_wrapsFinalized) {
      throw new Exception(
          'All interceptors must be added before adding routes or groups!');
    }
    if (interceptor == null) return this;
    _wrappers.add(interceptor);
    return this;
  }

  GroupBuilder onException(ExceptionHandler exceptionHandler) {
    if (_wrapsFinalized) {
      throw new Exception(
          'All interceptors must be added before adding routes or groups!');
    }
    if (exceptionHandler == null) return this;
    exceptionHandlers.add(exceptionHandler);
    return this;
  }

  RouteBuilder addRoute(RouteBuilder route) {
    final route1 = route.cloneWithPath(pathPrefix + route.path);
    route1.wrapAll(_wrappers);
    route1.onExceptionAll(exceptionHandlers);
    server.addRoute(route1);
    _wrapsFinalized = true;
    return route1;
  }

  RouteBuilder clone(RouteBuilder clone) {
    final route = new RouteBuilder(pathPrefix + clone.path, clone.handler,
        methods: clone.methods, pathRegEx: clone.pathRegEx);
    route.wrapAll(_wrappers);
    route.wrapAll(clone.interceptors);
    route.onExceptionAll(exceptionHandlers);
    route.onExceptionAll(clone.exceptionHandlers);
    server.addRoute(route);
    _wrapsFinalized = true;
    return route;
  }

  GroupBuilder group({String pathPrefix: ''}) {
    return new GroupBuilder(server, path: this.pathPrefix + (pathPrefix ?? ''));
  }
}

abstract class Muxable {
  RouteBuilder addRoute(RouteBuilder route);

  /// Add a route to be served
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

  /// Add a route with GET method to be served
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

  /// Add a route with POST method to be served
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

  /// Add a route with PUT method to be served
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

  /// Add a route with DELETE method to be served
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

  /// Add a route with PATCH method to be served
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

  /// Add a route with OPTIONS method to be served
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
}
