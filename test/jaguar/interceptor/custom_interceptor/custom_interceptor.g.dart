// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.interceptor.custom_interceptor;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/random')
  ];

  final ExampleApi _internal;

  JaguarExampleApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getRandom
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      ctx.addInterceptor(_internal.genRandom);
      ctx.addInterceptor(_internal.usesRandom);
      return await Interceptor.chain(ctx, _internal.getRandom, routes[0]);
    }

    return null;
  }
}
