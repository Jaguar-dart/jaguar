// GENERATED CODE - DO NOT MODIFY BY HAND

part of bootstrap.gen;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarAuthorRoutes implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get()];

  String get(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/author';
    bool match = false;

//Handler for get
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, get, routes[0]);
    }

    return null;
  }
}
