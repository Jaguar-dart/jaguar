part of jaguar.mux;

class GroupBuilder extends Object with Muxable {
  final Muxable server;

  final String pathPrefix;

  final List<RouteFunc> before = [];

  final List<RouteFunc> after = [];

  final List<ExceptionHandler> onException = [];

  GroupBuilder(this.server, {String path: ''}) : pathPrefix = path ?? '';

  Route addRoute(Route route) {
    final route1 = route.cloneWith(path: pathPrefix + route.info.path);
    route1.before.insertAll(0, before);
    route1.after.insertAll(0, after);
    route1.onException.insertAll(0, onException);
    server.addRoute(route1);
    return route1;
  }

  GroupBuilder group({String pathPrefix: ''}) =>
      new GroupBuilder(server, path: this.pathPrefix + (pathPrefix ?? ''));
}
