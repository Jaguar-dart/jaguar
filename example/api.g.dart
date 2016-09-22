// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// Generator: ApiClass
// Target: class TestApi
// **************************************************************************

abstract class _$JaguarTestApi {
  List<Route> _routes;

  void _initRoute() {
    _routes = <Route>[];
    _addRoute(new Route("/test/v1/ping", ["GET"], get));
    _addRoute(new Route("/test/v1/users/", ["GET"], users.getUser));
    _addRoute(new Route(
        "/test/v1/users/([a-zA-Z0-9]+)", ["GET"], users.getUserWithId));
  }

  void _addRoute(Route route) {
    _routes.add(route);
  }

  Route _getRoute(List<String> args, String path, String method) {
    return _routes.firstWhere(
        (Route route) =>
            route.matchWithRequestPathAndMethod(args, path, method),
        orElse: () => null);
  }

  Future<bool> handleApiRequest(HttpRequest request) async {
    if (_routes == null) _initRoute();
    List<String> args = <String>[];
    Route route = _getRoute(args, request.uri.path, request.method);
    if (route != null) {
      if (args.isNotEmpty)
        await route.function(request, args);
      else
        await route.function(request);
      return true;
    }
    return false;
  }
}
