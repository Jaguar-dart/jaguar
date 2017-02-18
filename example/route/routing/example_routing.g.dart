// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
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

  final BooksApi _internal;

  factory JaguarBooksApi() {
    final instance = new BooksApi();
    return new JaguarBooksApi.from(instance);
  }
  JaguarBooksApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    ContextImpl ctx = new ContextImpl(request);
    bool match = false;

//Handler for getAllBooks
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getAllBooks();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for getAllBooks1
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getAllBooks1();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for getAllBooks2
    match = routes[2]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getAllBooks2();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for defaultStatusAndHeader
    match = routes[3]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<dynamic> rRouteResponse0 = new Response(null);
      try {
        _internal.defaultStatusAndHeader();
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for inputHttpRequest
    match = routes[4]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<dynamic> rRouteResponse0 = new Response(null);
      try {
        _internal.inputHttpRequest(
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
