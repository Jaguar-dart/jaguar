// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/books'),
    const Route(path: '/books', methods: const <String>['GET']),
    const Get(path: '/books'),
    const Post(
        path: '/inject/httprequest',
        statusCode: 200,
        headers: const {'custom-header': 'custom data'})
  ];

  final BooksApi _internal;

  JaguarBooksApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/book';
    bool match = false;

//Handler for getFive
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.getFive, routes[0]);
    }

//Handler for getName
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.getName, routes[1]);
    }

//Handler for getMoto
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.getMoto, routes[2]);
    }

//Handler for defaultStatusAndHeader
    match = routes[3].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.defaultStatusAndHeader, routes[3]);
    }

    return null;
  }
}
