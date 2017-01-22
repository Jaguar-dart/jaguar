// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.response.stream;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/stream')
  ];

  Stream<List<int>> getStream();

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getStream
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Stream> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = getStream();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
