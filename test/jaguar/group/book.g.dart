// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group.normal.book;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class BookApi
// **************************************************************************

abstract class _$JaguarBookApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(path: '/some/:param1', methods: const <String>['POST'])
  ];

  String getBook();

  String some(String param1);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getBook
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.value = getBook();
        await rRouteResponse0.writeResponse(request.response);
      } catch (e) {
        rethrow;
      }
      return true;
    }

//Handler for some
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.value = some(
          (pathParams.getField('param1')),
        );
        await rRouteResponse0.writeResponse(request.response);
      } catch (e) {
        rethrow;
      }
      return true;
    }

    return false;
  }
}
