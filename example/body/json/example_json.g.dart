// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.body.json;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

abstract class _$JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Post(),
    const Get(path: '/:id'),
    const Delete(path: '/:id'),
    const Put(path: '/:id')
  ];

  Map<dynamic, dynamic> addBook(Map<String, dynamic> json);

  Map<dynamic, dynamic> getById(String id);

  Map<dynamic, dynamic> removeBook(String id);

  Map<dynamic, dynamic> updateBook(Map<String, dynamic> json, String id);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for addBook
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson = new WrapEncodeToJson().createInterceptor();
      DecodeJsonMap iDecodeJsonMap =
          new WrapDecodeJsonMap().createInterceptor();
      Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
        request,
      );
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = addBook(
        rDecodeJsonMap,
      );
      Response<String> rRouteResponse1 = iEncodeToJson.post(
        rRouteResponse0,
      );
      await rRouteResponse1.writeResponse(request.response);
      return true;
    }

//Handler for getById
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson = new WrapEncodeToJson().createInterceptor();
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = getById(
        (pathParams.getField('id')),
      );
      Response<String> rRouteResponse1 = iEncodeToJson.post(
        rRouteResponse0,
      );
      await rRouteResponse1.writeResponse(request.response);
      return true;
    }

//Handler for removeBook
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson = new WrapEncodeToJson().createInterceptor();
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = removeBook(
        (pathParams.getField('id')),
      );
      Response<String> rRouteResponse1 = iEncodeToJson.post(
        rRouteResponse0,
      );
      await rRouteResponse1.writeResponse(request.response);
      return true;
    }

//Handler for updateBook
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson = new WrapEncodeToJson().createInterceptor();
      DecodeJsonMap iDecodeJsonMap =
          new WrapDecodeJsonMap().createInterceptor();
      Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
        request,
      );
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = updateBook(
        rDecodeJsonMap,
        (pathParams.getField('id')),
      );
      Response<String> rRouteResponse1 = iEncodeToJson.post(
        rRouteResponse0,
      );
      await rRouteResponse1.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
