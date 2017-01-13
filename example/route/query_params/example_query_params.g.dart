// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

abstract class _$JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Post()];

  void createBook({String book, String author});

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
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
        createBook(
          book: (queryParams.getField('book')),
          author: (queryParams.getField('author')),
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
