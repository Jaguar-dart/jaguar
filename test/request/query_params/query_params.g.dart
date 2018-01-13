// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.query_params;

// **************************************************************************
// Generator: ApiGenerator
// **************************************************************************

abstract class _$JaguarQueryParamsExampleApi implements RequestHandler {
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

  String stringParam(Context ctx);
  String intParam(Context ctx);
  String doubleParam(Context ctx);
  String numParam(Context ctx);
  String defStringParam(Context ctx);
  String defIntParam(Context ctx);
  String defDoubleParam(Context ctx);
  String defDumParam(Context ctx);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for stringParam
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, stringParam, routes[0]);
    }

//Handler for intParam
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, intParam, routes[1]);
    }

//Handler for doubleParam
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, doubleParam, routes[2]);
    }

//Handler for numParam
    match = routes[3].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, numParam, routes[3]);
    }

//Handler for defStringParam
    match = routes[4].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, defStringParam, routes[4]);
    }

//Handler for defIntParam
    match = routes[5].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, defIntParam, routes[5]);
    }

//Handler for defDoubleParam
    match = routes[6].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, defDoubleParam, routes[6]);
    }

//Handler for defDumParam
    match = routes[7].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(ctx, defDumParam, routes[7]);
    }

    return null;
  }
}
