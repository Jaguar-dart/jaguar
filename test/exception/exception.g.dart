// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.exception.exception;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/user'),
    const Post(path: '/user')
  ];

  String getUser({String who});

  User post(User user);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for getUser
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      try {
        rRouteResponse.statusCode = 200;
        rRouteResponse.value = getUser(
          who: (queryParams.getField('who')),
        );
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      } on CustomException catch (e, s) {
        CustomExceptionHandler handler = new CustomExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      }
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

//Handler for post
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response rRouteResponse = new Response(null);
      try {
        UserParser iUserParser = new UserParser();
        User rUserParser = iUserParser.pre(
          new QueryParams.FromQueryParam(queryParams),
        );
        rRouteResponse.statusCode = 200;
        rRouteResponse.value = post(
          rUserParser,
        );
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      }
      await rRouteResponse.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
