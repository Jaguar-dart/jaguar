// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarExampApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/five'),
    const Route(path: '/name', methods: const <String>['GET']),
    const Get(path: '/moto'),
    const Post(
        path: '/default',
        statusCode: 200,
        headers: const {'custom-header': 'custom data'})
  ];

  int getFive(Context ctx);
  String getName(Context ctx);
  String getMoto(Context ctx);
  void defaultStatusAndHeader(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/book';
    bool match = false;

//Handler for getFive
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, getFive, routes[0]);
    }

//Handler for getName
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, getName, routes[1]);
    }

//Handler for getMoto
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, getMoto, routes[2]);
    }

//Handler for defaultStatusAndHeader
    match = routes[3].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, defaultStatusAndHeader, routes[3]);
    }

    return null;
  }
}
