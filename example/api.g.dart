// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// Generator: ApiAnnotationGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations("/test/v1/ping/([a-z]+)", ["POST"]),
    new RouteInformations("/test/v1/test", ["POST"]),
    new RouteInformations("/test/v1/users/", ["POST"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      ping(
        args[0],
      );
      return true;
    }
    match = _routes[1]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      String _openDbExample0 = await openDbExample(
        "test2",
      );
      String _openDbExample1 = await openDbExample(
        "test1",
      );
      Map<String, String> result = test(
        _openDbExample0,
        _openDbExample1,
      );
      encodeMapOrListToJson(
        request,
        result,
      );
      await closeDbExample(
        _openDbExample0,
      );
      await closeDbExample(
        _openDbExample1,
      );
      return true;
    }
    match = _routes[2]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      var result = users.users();
      return true;
    }
    return false;
  }
}
