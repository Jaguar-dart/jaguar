// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group.normal.book;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarBookApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(path: '/some/:param1', methods: const <String>['POST'])
  ];

  String getBook(Context ctx);
  String some(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    bool match = false;

//Handler for getBook
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, getBook, routes[0]);
    }

//Handler for some
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, some, routes[1]);
    }

    return null;
  }
}
