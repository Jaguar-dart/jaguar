// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.exception.exception;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get('/user'),
    const Post('/user')
  ];

  String getUser({String who});

  User post(User user);

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      try {
        String rRouteResponse;
        rRouteResponse = getUser(
          who: (queryParams.getField('who')),
        );
        request.response.statusCode = 200;
        request.response.write(rRouteResponse.toString());
        await request.response.close();
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      } on CustomException catch (e, s) {
        CustomExceptionHandler handler = new CustomExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      }
      return true;
    }

    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      try {
        UserParser iUserParser = new UserParser();
        User rUserParser = iUserParser.pre(
          queryParams,
        );
        User rRouteResponse;
        rRouteResponse = post(
          rUserParser,
        );
        request.response.statusCode = 200;
        request.response.write(rRouteResponse.toString());
        await request.response.close();
      } on ValidationException catch (e, s) {
        ValidationExceptionHandler handler = new ValidationExceptionHandler();
        handler.onRouteException(request, e, s);
        return true;
      }
      return true;
    }

    return false;
  }
}
