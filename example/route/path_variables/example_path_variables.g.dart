// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/book/:id'),
    const Post(path: '/book/:book/:author')
  ];

  final BooksApi _internal;

  factory JaguarBooksApi() {
    final instance = new BooksApi();
    return new JaguarBooksApi.from(instance);
  }
  JaguarBooksApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    ContextImpl ctx = new ContextImpl(request);
    bool match = false;

//Handler for getBookById
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      try {
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getBookById(
          (ctx.pathParams.getField('id')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

//Handler for createBook
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<dynamic> rRouteResponse0 = new Response(null);
      try {
        _internal.createBook(
          (ctx.pathParams.getField('book')),
          (ctx.pathParams.getField('author')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
