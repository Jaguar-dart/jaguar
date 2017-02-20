// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.interceptor.wrapper_creator;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/random')
  ];

  final ExampleApi _internal;

  factory JaguarExampleApi() {
    final instance = new ExampleApi();
    return new JaguarExampleApi.from(instance);
  }
  JaguarExampleApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    ContextImpl ctx = new ContextImpl(request);
    bool match = false;

//Handler for getRandom
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson0;
      GenRandom iGenRandom0;
      UsesRandom iUsesRandom0;
      try {
        final RouteWrapper wEncodeToJson0 = _internal.jsonEncoder();
        iEncodeToJson0 = wEncodeToJson0.createInterceptor();
        final RouteWrapper wGenRandom0 = _internal.genRandom();
        iGenRandom0 = wGenRandom0.createInterceptor();
        int rGenRandom0 = iGenRandom0.pre();
        ctx.addOutput(GenRandom, wGenRandom0.id, iGenRandom0, rGenRandom0);
        final RouteWrapper wUsesRandom0 = _internal.usesRandom(
          ctx.getInput(GenRandom),
        );
        iUsesRandom0 = wUsesRandom0.createInterceptor();
        int rUsesRandom0 = iUsesRandom0.pre();
        ctx.addOutput(UsesRandom, wUsesRandom0.id, iUsesRandom0, rUsesRandom0);
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getRandom(
          ctx.getInput(GenRandom),
          ctx.getInput(UsesRandom),
        );
        Response<String> rRouteResponse1 = iEncodeToJson0.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iUsesRandom0?.onException();
        await iGenRandom0?.onException();
        await iEncodeToJson0?.onException();
        rethrow;
      }
    }

    return null;
  }
}
