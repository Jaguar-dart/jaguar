// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group.normal.book;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class BookApi
// **************************************************************************

class JaguarBookApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(path: '/some/:param1', methods: const <String>['POST'])
  ];

  final BookApi _internal;

  factory JaguarBookApi() {
    final instance = new BookApi();
    return new JaguarBookApi.from(instance);
  }
  JaguarBookApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getBook
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      ContextImpl ctx = new ContextImpl(request, pathParams);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getBook();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for some
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      ContextImpl ctx = new ContextImpl(request, pathParams);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.some(
          (pathParams.getField('param1')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
