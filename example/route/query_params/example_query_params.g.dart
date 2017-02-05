// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Post()];

  final BooksApi _internal;

  factory JaguarBooksApi() {
    final instance = new BooksApi();
    return new JaguarBooksApi.from(instance);
  }
  JaguarBooksApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for createBook
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<dynamic> rRouteResponse0 = new Response(null);
      try {
        _internal.createBook(
          book: (queryParams.getField('book')),
          author: (queryParams.getField('author')),
        );
        return rRouteResponse0;
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }
}
