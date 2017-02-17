// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(),
    const Post()
  ];

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
      EncodeToJson iEncodeToJson;
      try {
        iEncodeToJson = _internal.jsonEncoder.createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getJaguarInfo();
        Response<String> rRouteResponse1 = iEncodeToJson.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeToJson?.onException();
        rethrow;
      }
    }

//Handler for createJaguarInfo
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      ContextImpl ctx = new ContextImpl(request, pathParams);
      DecodeJsonMap iDecodeJsonMap;
      EncodeToJson iEncodeToJson;
      try {
        iEncodeToJson = _internal.jsonEncoder.createInterceptor();
        iDecodeJsonMap = _internal.jsonDecoder.createInterceptor();
        ctx.addInterceptorOutput(_internal.jsonDecoder, iDecodeJsonMap,
            await iDecodeJsonMap.pre(request));
        Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
          request,
        );
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.createJaguarInfo(
          rDecodeJsonMap,
        );
        ctx.getInterceptorOutput(DecodeJsonMap, id: )
        return rRouteResponse0;
      } catch (e) {
        await iDecodeJsonMap?.onException();
        rethrow;
      }
    }

    return null;
  }
}
