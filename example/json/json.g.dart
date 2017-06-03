// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.body.json;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Post()];

  final BooksApi _internal;

  JaguarBooksApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    final ctx = new Context(request);
    bool match = false;

//Handler for addBook
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.addBook, routes[0]);
    }

    return null;
  }
}
