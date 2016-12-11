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

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getAllBooks
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getAllBooks();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for getAllBooks1
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getAllBooks1();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for getAllBooks2
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getAllBooks2();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for defaultStatusAndHeader
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      defaultStatusAndHeader();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for inputHttpRequest
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      inputHttpRequest(
        request,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
