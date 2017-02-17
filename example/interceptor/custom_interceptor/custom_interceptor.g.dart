// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[const Get()];

  final BooksApi _internal;

  factory JaguarBooksApi() {
    final instance = new BooksApi();
    return new JaguarBooksApi.from(instance);
  }
  JaguarBooksApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getJaguarInfo
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      ContextImpl ctx = new ContextImpl(request, pathParams);
      EncodeToJson iEncodeToJson0;
      GenRandom iGenRandom0;
      UsesRandom iUsesRandom0;
      try {
        final RouteWrapper wEncodeToJson0 = _internal.jsonEncoder();
        iEncodeToJson0 = wEncodeToJson0.createInterceptor();
        final RouteWrapper wGenRandom0 = _internal.genRandom();
        iGenRandom0 = wGenRandom0.createInterceptor();
        int rGenRandom0 = iGenRandom0.pre();
        ctx.addOutput(wGenRandom0, iGenRandom0, rGenRandom0);
        final RouteWrapper wUsesRandom0 = _internal.usesRandom();
        iUsesRandom0 = wUsesRandom0.createInterceptor();
        iUsesRandom0.pre();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getJaguarInfo();
        iUsesRandom0.post();
        iGenRandom0.post();
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
