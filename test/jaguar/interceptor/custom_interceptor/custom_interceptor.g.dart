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

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    final ctx = new Context(request);
    bool match = false;

//Handler for getRandom
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      interceptors.add(_internal.genRandom(ctx));
      interceptors.add(_internal.usesRandom(ctx));
      return await Interceptor.chain(
          ctx, interceptors, _internal.getRandom, routes[0]);
    }

    return null;
  }
}
