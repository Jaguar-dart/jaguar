// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.interceptor.inject_request;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

class JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/echo/uri')
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

//Handler for getJaguarInfo
    match = routes[0]
        .match(request.uri.path, request.method, prefix, ctx.pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson0;
      UsesRequest iUsesRequest0;
      try {
        final RouteWrapper wEncodeToJson0 = _internal.jsonEncoder();
        iEncodeToJson0 = wEncodeToJson0.createInterceptor();
        final RouteWrapper wUsesRequest0 = _internal.usesRequest();
        iUsesRequest0 = wUsesRequest0.createInterceptor();
        String rUsesRequest0 = iUsesRequest0.pre(
          request,
        );
        ctx.addOutput(
            UsesRequest, wUsesRequest0.id, iUsesRequest0, rUsesRequest0);
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getJaguarInfo(
          ctx.getInput(UsesRequest),
        );
        Response<String> rRouteResponse1 = iEncodeToJson0.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iUsesRequest0?.onException();
        await iEncodeToJson0?.onException();
        rethrow;
      }
    }

    return null;
  }
}
