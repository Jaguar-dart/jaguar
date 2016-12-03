// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.interceptor.state;

// **************************************************************************
// Generator: ApiGenerator
// Target: class StateApi
// **************************************************************************

abstract class _$JaguarStateApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Route(path: '/user', methods: const <String>['GET'])
  ];

  void getUser();

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for getUser
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      WithState iWithState = new WithState(
        state: WithState.createState(),
      );
      iWithState.pre();
      getUser();
      rRouteResponse = iWithState.post(
        rRouteResponse,
      );
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
