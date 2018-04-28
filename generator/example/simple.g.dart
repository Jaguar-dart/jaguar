// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.example.routes.simple;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarSubGroup implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/ping'),
    const Put(path: '/void'),
    const Put(path: '/map/empty')
  ];

  Future<String> normal(Context ctx);

  void voidRoute(Context ctx);

  Future<Response<String>> jsonRoute(Context ctx);

  Interceptor sampleInterceptor3(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    bool match = false;

//Handler for normal
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      try {
        final interceptors = <InterceptorCreator>[
          SubGroup.sampleInterceptor,
          sampleInterceptor2,
          this.sampleInterceptor3,
        ];
        return await Interceptor.chain(ctx, interceptors, normal, routes[0]);
      } catch (e, s) {
        {
          ExceptHandler handler = new ExceptHandler();
          final exResp = await handler.onRouteException(ctx, e, s);
          if (exResp != null) return exResp;
        }
        rethrow;
      }
    }

//Handler for voidRoute
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return new Response.fromRoute(voidRoute(ctx), routes[1]);
    }

//Handler for jsonRoute
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await jsonRoute(ctx);
    }

    return null;
  }
}

abstract class _$JaguarMotherGroup implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/ping')
  ];

  String ping(Context ctx);

  SubGroup get subGroup;

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for ping
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return new Response.fromRoute(ping(ctx), routes[0]);
    }

    {
      Response response =
          await subGroup.handleRequest(ctx, prefix: prefix + '/sub');
      if (response is Response) {
        return response;
      }
    }

    return null;
  }
}
