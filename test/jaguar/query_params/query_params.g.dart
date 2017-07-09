// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.query_params;

// **************************************************************************
// Generator: ApiGenerator
// Target: class QueryParamsExampleApi
// **************************************************************************

class JaguarQueryParamsExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/stringParam'),
    const Get(path: '/intParam'),
    const Get(path: '/doubleParam'),
    const Get(path: '/numParam'),
    const Get(path: '/defStringParam'),
    const Get(path: '/defIntParam'),
    const Get(path: '/defDoubleParam'),
    const Get(path: '/defNumParam')
  ];

  final QueryParamsExampleApi _internal;

  JaguarQueryParamsExampleApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for stringParam
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.stringParam, routes[0]);
    }

//Handler for intParam
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.intParam, routes[1]);
    }

//Handler for doubleParam
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.doubleParam, routes[2]);
    }

//Handler for numParam
    match = routes[3].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.numParam, routes[3]);
    }

//Handler for defStringParam
    match = routes[4].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.defStringParam, routes[4]);
    }

//Handler for defIntParam
    match = routes[5].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.defIntParam, routes[5]);
    }

//Handler for defDoubleParam
    match = routes[6].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.defDoubleParam, routes[6]);
    }

//Handler for defDumParam
    match = routes[7].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.defDumParam, routes[7]);
    }

    return null;
  }
}
