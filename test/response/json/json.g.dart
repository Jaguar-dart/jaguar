// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.response.json;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/info'),
    const Post(path: '/info')
  ];

  Response<String> getJaguarInfo(Context ctx);
  Response<String> createJaguarInfo(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getJaguarInfo
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, getJaguarInfo, routes[0]);
    }

//Handler for createJaguarInfo
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, createJaguarInfo, routes[1]);
    }

    return null;
  }
}
