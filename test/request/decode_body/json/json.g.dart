// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.decode_body.json;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarJsonDecode implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Post(path: '/one'),
    const Post(path: '/many'),
    const Post(path: '/doubled')
  ];

  Future<String> addOne(Context ctx);

  Future<String> addMany(Context ctx);

  Future<String> doubled(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/add';
    bool match = false;

//Handler for addOne
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return new Response.fromRoute(await addOne(ctx), routes[0]);
    }

//Handler for addMany
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return new Response.fromRoute(await addMany(ctx), routes[1]);
    }

//Handler for doubled
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return new Response.fromRoute(await doubled(ctx), routes[2]);
    }

    return null;
  }
}
