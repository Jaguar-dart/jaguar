// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.interceptor.inject_request;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/echo/uri')
  ];

  final ExampleApi _internal;

  JaguarExampleApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getJaguarInfo
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      ctx.addInterceptor(_internal.usesRequest);
      return await Interceptor.chain(ctx, _internal.getJaguarInfo, routes[0]);
    }

    return null;
  }
}
