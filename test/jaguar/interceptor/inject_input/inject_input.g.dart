// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.interceptor.inject_request;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/echo/uri')
  ];

  Response<String> getJaguarInfo(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getJaguarInfo
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      ctx.addInterceptor(ExampleApi.usesRequest);
      return await Interceptor.chain(ctx, getJaguarInfo, routes[0]);
    }

    return null;
  }
}
