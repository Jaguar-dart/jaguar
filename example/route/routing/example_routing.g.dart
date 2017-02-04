// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

abstract class _$JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/books'),
    const Route(path: '/books', methods: const <String>['GET']),
    const Get(path: '/books'),
    const Post(
        path: '/inject/httprequest',
        statusCode: 200,
        headers: const {'custom-header': 'custom data'}),
    const Post(path: '/inject/httprequest')
  ];

  List<Map<dynamic, dynamic>> getAllBooks();

  List<Map<dynamic, dynamic>> getAllBooks1();

  List<Map<dynamic, dynamic>> getAllBooks2();

  void defaultStatusAndHeader();

  void inputHttpRequest(HttpRequest req);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getAllBooks
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = getAllBooks();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for getAllBooks1
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = getAllBooks1();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for getAllBooks2
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = getAllBooks2();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for defaultStatusAndHeader
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<dynamic> rRouteResponse0 = new Response(null);
      try {
        defaultStatusAndHeader();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for inputHttpRequest
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<dynamic> rRouteResponse0 = new Response(null);
      try {
        inputHttpRequest(
          null,
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
