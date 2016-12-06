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
      Response rRouteResponse = new Response(null);
      EncodeToJson iEncodeToJson = new EncodeToJson();
      iEncodeToJson.pre(
        rRouteResponse,
      );
      DecodeJsonMap iDecodeJsonMap = new DecodeJsonMap();
      Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = addBook(
        rDecodeJsonMap,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for getById
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      EncodeToJson iEncodeToJson = new EncodeToJson();
      iEncodeToJson.pre(
        rRouteResponse,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = getById(
        (pathParams.getField('id')),
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for removeBook
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      EncodeToJson iEncodeToJson = new EncodeToJson();
      iEncodeToJson.pre(
        rRouteResponse,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = removeBook(
        (pathParams.getField('id')),
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for updateBook
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      EncodeToJson iEncodeToJson = new EncodeToJson();
      iEncodeToJson.pre(
        rRouteResponse,
      );
      DecodeJsonMap iDecodeJsonMap = new DecodeJsonMap();
      Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
        request,
      );
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = updateBook(
        rDecodeJsonMap,
        (pathParams.getField('id')),
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
