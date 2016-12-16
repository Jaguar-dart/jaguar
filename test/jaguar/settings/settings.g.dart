// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.settings;

// **************************************************************************
// Generator: ApiGenerator
// Target: class SettingsApi
// **************************************************************************

abstract class _$JaguarSettingsApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/getMap', methods: const <String>['GET']),
    const Route(path: '/getNotFoundMap', methods: const <String>['GET']),
    const Route(path: '/getMapDefault', methods: const <String>['GET']),
    const Route(path: '/getYaml', methods: const <String>['GET']),
    const Route(path: '/getNotFoundYaml', methods: const <String>['GET']),
    const Route(path: '/getYamlDefault', methods: const <String>['GET'])
  ];

  String getMap();

  String getNotFoundMap();

  String getMapDefault();

  String getYaml();

  String getNotFoundYaml();

  String getYamlDefault();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getMap
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = getMap();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for getNotFoundMap
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = getNotFoundMap();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for getMapDefault
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = getMapDefault();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for getYaml
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = getYaml();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for getNotFoundYaml
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = getNotFoundYaml();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for getYamlDefault
    match =
        routes[5].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = getYamlDefault();
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
