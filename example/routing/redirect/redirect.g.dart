// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class RedirectExampleApi
// **************************************************************************

class JaguarRedirectExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/tome'),
    const Get(path: '/redirectme', statusCode: HttpStatus.MOVED_PERMANENTLY),
    const Get(
        path: '/redirectme/withquery', statusCode: HttpStatus.MOVED_PERMANENTLY)
  ];

  final RedirectExampleApi _internal;

  JaguarRedirectExampleApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    final ctx = new Context(request);
    bool match = false;

//Handler for getBookById
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.getBookById, routes[0]);
    }

//Handler for redirectMe
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.redirectMe, routes[1]);
    }

//Handler for redirectWithQuery
    match = routes[2]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.redirectWithQuery, routes[2]);
    }

    return null;
  }
}
