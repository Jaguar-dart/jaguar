// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.route;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/user', methods: const <String>['GET']),
    const Get(path: '/statuscode', statusCode: 201),
    const Get(path: '/paramandquery/:param'),
    const Get(path: '/input/header'),
    const Get(path: '/input/headers'),
    const Get(path: '/input/cookie'),
    const Get(path: '/input/cookies')
  ];

  String getUser(Context ctx);
  String statusCode(Context ctx);
  String paramAndQuery(Context ctx);
  String inputHeader(Context ctx);
  String inputHeaders(Context ctx);
  String inputCookie(Context ctx);
  String inputCookies(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getUser
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, getUser, routes[0]);
    }

//Handler for statusCode
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, statusCode, routes[1]);
    }

//Handler for paramAndQuery
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, paramAndQuery, routes[2]);
    }

//Handler for inputHeader
    match = routes[3].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, inputHeader, routes[3]);
    }

//Handler for inputHeaders
    match = routes[4].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, inputHeaders, routes[4]);
    }

//Handler for inputCookie
    match = routes[5].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, inputCookie, routes[5]);
    }

//Handler for inputCookies
    match = routes[6].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, inputCookies, routes[6]);
    }

    return null;
  }
}
