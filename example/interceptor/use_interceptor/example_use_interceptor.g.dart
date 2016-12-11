// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

abstract class _$JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(),
    const Post()
  ];

  Map<dynamic, dynamic> getJaguarInfo();

  Map<dynamic, dynamic> createJaguarInfo(Map<dynamic, dynamic> body);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getJaguarInfo
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      EncodeToJson iEncodeToJson = new WrapEncodeToJson().createInterceptor();
      iEncodeToJson.pre(
        rRouteResponse,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getJaguarInfo();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for createJaguarInfo
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      DecodeJsonMap iDecodeJsonMap =
          new WrapDecodeJsonMap().createInterceptor();
      Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = createJaguarInfo(
        rDecodeJsonMap,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
