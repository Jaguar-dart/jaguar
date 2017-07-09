// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.decode_body.json;

// **************************************************************************
// Generator: ApiGenerator
// Target: class JsonDecode
// **************************************************************************

class JaguarJsonDecode implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Post(path: '/one'),
    const Post(path: '/many'),
    const Post(path: '/doubled')
  ];

  final JsonDecode _internal;

  JaguarJsonDecode(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api/add';
    bool match = false;

//Handler for addOne
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, ctx.interceptorCreators, _internal.addOne, routes[0]);
    }

//Handler for addMany
    match = routes[1].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, ctx.interceptorCreators, _internal.addMany, routes[1]);
    }

//Handler for doubled
    match = routes[2].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      return await Interceptor.chain(
          ctx, ctx.interceptorCreators, _internal.doubled, routes[2]);
    }

    return null;
  }
}
