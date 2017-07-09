// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.interceptor.custom_interceptor;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/random')
  ];

  final ExampleApi _internal;

  JaguarExampleApi(this._internal);

  Future<Response> handleRequest(Context ctx, {String prefix: ''}) async {
    prefix += '/api';
    bool match = false;

//Handler for getRandom
    match = routes[0].match(ctx.path, ctx.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <InterceptorCreator>[];
      interceptors.add(_internal.genRandom);
      interceptors.add(_internal.usesRandom);
      return await Interceptor.chain(
          ctx, interceptors, _internal.getRandom, routes[0]);
    }

    return null;
  }
}
