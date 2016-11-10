// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group.normal.book;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class BookApi
// **************************************************************************

abstract class _$JaguarBookApi implements RequestHandler {
  static const List<RouteBase> _routes = const <RouteBase>[
    const Route('', methods: const <String>['GET']),
    const Route('/some/:param1', methods: const <String>['POST'])
  ];

  String getBook();

  String some(String param1);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        _routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = getBook();
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    match =
        _routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      String rRouteResponse;
      rRouteResponse = some(
        (pathParams.getField('param1')),
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}
