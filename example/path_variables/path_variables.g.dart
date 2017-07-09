// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/book/:id'),
    const Get(path: '/book/:id'),
    const Get(path: '/book/:id'),
    const Get(path: '/book/:id')
  ];

  final BooksApi _internal;

  JaguarBooksApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getAsString
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.getAsString, routes[0]);
    }

//Handler for getAsInt
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.getAsInt, routes[1]);
    }

//Handler for getAsDouble
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.getAsDouble, routes[2]);
    }

//Handler for getAsNum
    match = routes[3].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, _internal.getAsNum, routes[3]);
    }

    return null;
  }
}
