// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group.normal.book;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BookApi
// **************************************************************************

class JaguarBookApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(path: '/some/:param1', methods: const <String>['POST'])
  ];

  final BookApi _internal;

  JaguarBookApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    bool match = false;

//Handler for getBook
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, ctx.interceptorCreators, _internal.getBook, routes[0]);
    }

//Handler for some
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, ctx.interceptorCreators, _internal.some, routes[1]);
    }

    return null;
  }
}
