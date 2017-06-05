// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(),
    const Get(),
    const Get(),
    const Get()
  ];

  final BooksApi _internal;

  JaguarBooksApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    final ctx = new Context(request);
    bool match = false;

//Handler for getAsString
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.getAsString, routes[0]);
    }

//Handler for getAsInt
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.getAsInt, routes[1]);
    }

//Handler for getAsDouble
    match = routes[2]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.getAsDouble, routes[2]);
    }

//Handler for getAsNum
    match = routes[3]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.getAsNum, routes[3]);
    }

    return null;
  }
}
