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

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    final ctx = new Context(request);
    bool match = false;

//Handler for stringParam
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.stringParam, routes[0]);
    }

//Handler for intParam
    match = routes[1]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.intParam, routes[1]);
    }

//Handler for doubleParam
    match = routes[2]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.doubleParam, routes[2]);
    }

//Handler for numParam
    match = routes[3]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.numParam, routes[3]);
    }

//Handler for defStringParam
    match = routes[4]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.defStringParam, routes[4]);
    }

//Handler for defIntParam
    match = routes[5]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.defIntParam, routes[5]);
    }

//Handler for defDoubleParam
    match = routes[6]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.defDoubleParam, routes[6]);
    }

//Handler for defDumParam
    match = routes[7]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptorCreators = <InterceptorCreator>[];
      return await Interceptor.chain(
          ctx, interceptorCreators, _internal.defDumParam, routes[7]);
    }

    return null;
  }
}
