// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.interceptor.custom_interceptor;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/random')
  ];

  Response<String> getRandom(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getRandom
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      ctx.addInterceptor(ExampleApi.genRandom);
      ctx.addInterceptor(ExampleApi.usesRandom);
      return await Interceptor.chain(ctx, getRandom, routes[0]);
    }

    return null;
  }
}
