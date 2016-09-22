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

  Future<bool> handleApiRequest(HttpRequest request) async {
    if (_routes == null) _initRoute();
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      Null result = await get(
        request,
      );
      return true;
    }
    match = _routes[1]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      String result = await users.getUser();
      int length = UTF8.encode(result).length;
      request.response
        ..contentLength = length
        ..write(result);
      return true;
    }
    match = _routes[2]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      users.getUserWithId(
        request,
        args[0],
      );
      return true;
    }
    return null;
  }
}
