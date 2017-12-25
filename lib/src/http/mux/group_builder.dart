part of jaguar.mux;

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
