part of jaguar.mux;

class GroupBuilder extends Object with Muxable {
  final Muxable parent;

  final String path;

  final List<RouteInterceptor> before = [];

  final List<RouteInterceptor> after = [];

  final List<ExceptionHandler> onException = [];

  GroupBuilder(this.parent, {this.path = ''});

  /// Adds all the given [routes] to be served
  void add(Iterable<Route> routes) {
    for (Route route in routes) addRoute(route);
  }

  Route addRoute(Route route) {
    final route1 = route.cloneWith(path: path + route.info.path);
    route1._before.insertAll(0, before);
    route1._after.insertAll(0, after);
    route1._onException.insertAll(0, onException);
    parent.addRoute(route1);
    return route1;
  }

  GroupBuilder group({String path = ''}) =>
      GroupBuilder(parent, path: this.path + path);
}
