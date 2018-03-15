// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get()];

  Response<String> getJaguarInfo(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/book';
    bool match = false;

//Handler for getJaguarInfo
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[
        BooksApi.genRandom,
        BooksApi.usesRandom,
      ];
      return await Interceptor.chain(
          ctx, interceptors, getJaguarInfo, routes[0]);
    }

    return null;
  }
}
