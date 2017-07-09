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

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/book';
    bool match = false;

//Handler for getJaguarInfo
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      interceptors.add(_internal.genRandom);
      interceptors.add(_internal.usesRandom);
      return await Interceptor.chain(
          ctx, interceptors, _internal.getJaguarInfo, routes[0]);
    }

    return null;
  }
}
