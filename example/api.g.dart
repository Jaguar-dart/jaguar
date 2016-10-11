// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// Generator: ApiAnnotationGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations(r"/test/v1/ping/([a-z]+)", ["POST"]),
    new RouteInformations(r"/test/v1/test", ["POST"]),
    new RouteInformations(r"/test/v1/users/", ["POST"]),
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
      Map<String, String> result = test();
      encodeMapOrListToJson(
        request,
        result,
      );
      return true;
    }
    match = _routes[2]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      var result = users.users(
        request,
      );
      request.response.write(result);
      return true;
    }
    return false;
  }
}
