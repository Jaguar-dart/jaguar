// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.interceptor.param;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements ApiInterface {
  static const List<RouteBase> _routes = const <RouteBase>[
    const Route('/user', methods: const <String>['GET'])
  ];

  String getUser(String who);

  Future<bool> handleApiRequest(HttpRequest request) async {
    PathParams pathParams = new PathParams();
    bool match = false;

    match =
        _routes[0].match(request.uri.path, request.method, '/api', pathParams);
    if (match) {
      WithParam iWithParam = new WithParam(
        params: const {#checker: CheckerImpl},
        checker: new CheckerImpl(),
      );
      String rWithParam = iWithParam.pre();
      String rRouteResponse;
      rRouteResponse = getUser(
        rWithParam,
      );
      request.response.statusCode = 200;
      request.response.write(rRouteResponse.toString());
      await request.response.close();
      return true;
    }

    return false;
  }
}
