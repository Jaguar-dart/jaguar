// GENERATED CODE - DO NOT MODIFY BY HAND

part of bootstrap.gen;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

class JaguarAuthorRoutes implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get()];

  final AuthorRoutes _internal;

  JaguarAuthorRoutes(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/author';
    bool match = false;

//Handler for get
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.get, routes[0]);
    }

    return null;
  }
}
