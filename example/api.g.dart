// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// Generator: ApiClass
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi {
  List<RouteInformations> _routes;

  void _initRoute() {
    _routes = <RouteInformations>[];
    _addRoute(new RouteInformations("/test/v1/ping", ["GET"], get));
    _addRoute(new RouteInformations("/test/v1/users/", ["GET"], users.getUser));
    _addRoute(new RouteInformations(
        "/test/v1/users/([a-zA-Z0-9]+)", ["GET"], users.getUserWithId));
  }

  void _addRoute(RouteInformations route) {
    _routes.add(route);
  }

  RouteInformations _getRoute(List<String> args, String path, String method) {
    return _routes.firstWhere(
        (RouteInformations route) =>
            route.matchWithRequestPathAndMethod(args, path, method),
        orElse: () => null);
  }

  Future<bool> handleApiRequest(HttpRequest request) async {
    if (_routes == null) _initRoute();
    List<String> args = <String>[];
    RouteInformations route = _getRoute(args, request.uri.path, request.method);
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
