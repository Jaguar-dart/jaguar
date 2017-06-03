// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.response.stream;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/stream')
  ];

  final ExampleApi _internal;

  JaguarExampleApi(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    final ctx = new Context(request);
    bool match = false;

//Handler for getStream
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      final interceptors = <Interceptor>[];
      return await Interceptor.chain(
          ctx, interceptors, _internal.getStream, routes[0]);
    }

    return null;
  }
}
