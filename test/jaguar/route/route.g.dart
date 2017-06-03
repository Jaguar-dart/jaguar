// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.route;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/user', methods: const <String>['GET']),
    const Get(path: '/statuscode', statusCode: 201),
    const Get(path: '/paramandquery/:param'),
    const Get(path: '/input/header'),
    const Get(path: '/input/headers'),
    const Get(path: '/input/cookie'),
    const Get(path: '/input/cookies')
  ];

  final ExampleApi _internal;

  JaguarExampleApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    final ctx = new Context(request);
    bool match = false;

//Handler for getUser
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.getUser, routes[0]);
    }

//Handler for statusCode
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.statusCode, routes[1]);
    }

//Handler for paramAndQuery
    match = routes[2]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.paramAndQuery, routes[2]);
    }

//Handler for inputHeader
    match = routes[3]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.inputHeader, routes[3]);
    }

//Handler for inputHeaders
    match = routes[4]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.inputHeaders, routes[4]);
    }

//Handler for inputCookie
    match = routes[5]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.inputCookie, routes[5]);
    }

//Handler for inputCookies
    match = routes[6]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.inputCookies, routes[6]);
    }

    return null;
  }
}
