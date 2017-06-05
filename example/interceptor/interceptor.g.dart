// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get()];

  final BooksApi _internal;

  JaguarBooksApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    final ctx = new Context(request);
    bool match = false;

//Handler for getJaguarInfo
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      interceptorCreators.add(_internal.genRandom);
      interceptorCreators.add(_internal.usesRandom);
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.getJaguarInfo, routes[0]);
    }

    return null;
  }
}
