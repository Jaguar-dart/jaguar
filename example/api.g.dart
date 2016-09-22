// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// Generator: ApiClass
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations("/test/v1/ping", ["GET"]),
    new RouteInformations("/test/v1/users/", ["GET"]),
    new RouteInformations("/test/v1/users/([a-zA-Z0-9]+)", ["GET"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
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
        toto: request.requestedUri.queryParameters['toto'],
      );
      return true;
    }
    return null;
  }
}
