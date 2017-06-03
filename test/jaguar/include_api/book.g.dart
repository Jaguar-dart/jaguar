// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.group.normal.book;

// **************************************************************************
// Generator: RouteGroupGenerator
// Target: class BookApi
// **************************************************************************

class JaguarBookApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(methods: const <String>['GET']),
    const Route(path: '/some/:param1', methods: const <String>['POST'])
  ];

  final BookApi _internal;

  JaguarBookApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    final ctx = new Context(request);
    bool match = false;

//Handler for getBook
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.getBook, routes[0]);
    }

//Handler for some
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.some, routes[1]);
    }

    return null;
  }
}
