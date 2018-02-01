// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.response.stream;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/stream')
  ];

  Stream<List<int>> getStream(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getStream
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return new Response.fromRoute(getStream(ctx), routes[0]);
    }

    return null;
  }
}
