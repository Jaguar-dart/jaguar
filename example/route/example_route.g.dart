// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.routes;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

abstract class _$JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(
        path: '/books',
        methods: const <String>['GET'],
        statusCode: 201,
        headers: const {"sample-header": "made-with.jaguar"}),
    const Get(
        statusCode: 201, headers: const {"sample-header": "made-with.jaguar"}),
    const Delete(path: '/:id'),
    const Post(path: '/inject/httprequest'),
    const Route(path: '/user', methods: const <String>['DELETE'])
  ];

  List<Map<dynamic, dynamic>> routeAnnotation();

  List<Map<dynamic, dynamic>> getAnnotation();

  Map<dynamic, dynamic> pathParameter(String id);

  void inputHttpRequest(HttpRequest req);

  void delete(HttpRequest request, Db db);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for routeAnnotation
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 201;
      rRouteResponse.headers['sample-header'] = 'made-with.jaguar';
      rRouteResponse.value = routeAnnotation();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for getAnnotation
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 201;
      rRouteResponse.headers['sample-header'] = 'made-with.jaguar';
      rRouteResponse.value = getAnnotation();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for pathParameter
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      rRouteResponse.statusCode = 200;
      rRouteResponse.value = pathParameter(
        (pathParams.getField('id')),
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for inputHttpRequest
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      inputHttpRequest(
        request,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for delete
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      MongoDb iMongoDb = new MongoDb(
        'store',
        state: MongoDb.createState(),
      );
      Db rMongoDb = await iMongoDb.pre();
      delete(
        request,
        rMongoDb,
      );
      await iMongoDb.post();
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
