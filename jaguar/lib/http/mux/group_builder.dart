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
    final route1 = route.cloneWith(
      info: route.info.cloneWith(path: path + route.info.path),
      before: [...before, ...route.getBefore()],
      after: [...after, ...route.getAfter()],
      onException: [...onException, ...route.getOnException()],
    );
    parent.addRoute(route1);
    return route1;
  }

  GroupBuilder group({String path = ''}) =>
      GroupBuilder(parent, path: this.path + path)
        ..before.addAll(before)
        ..after.addAll(after)
        ..onException.addAll(onException);
}
