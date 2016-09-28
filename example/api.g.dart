// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// Generator: ApiClass
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations("/test/v1/ping", ["POST"]),
    new RouteInformations("/test/v1/test", ["POST"]),
    new RouteInformations("/test/v1/users/", ["POST"]),
    new RouteInformations("/test/v1/users/([a-zA-Z0-9]+)", ["GET"]),
  ];

  void mustBeContentType(HttpRequest request, ContentType contentType) {
    if (request.headers.contentType.value != contentType.value) {
      String value = request.headers.contentType?.value ?? '';
      throw new BadRequestError(
          'The request has content type $value instead of $contentType');
    }
    if (contentType.charset != null &&
        request.headers.contentType.charset != contentType.charset) {
      String value = request.headers.contentType?.charset ?? '';
      throw new BadRequestError(
          'The request has charset $value instead of ${contentType.charset}');
    }
  }

  Future<String> getDataFromBodyInUtf8(HttpRequest request) async {
    Completer<String> completer = new Completer<String>();
    String datas = '';
    request.transform(UTF8.decoder).listen((String data) {
      datas += data;
    },
        onDone: () => completer.complete(datas),
        onError: (dynamic error) => completer.completeError(error));
    return completer.future;
  }

  Future<dynamic> getJsonFromBodyInUtf8(HttpRequest request) async {
    mustBeContentType(request, ContentType.parse('application/json'));
    if (request.contentLength <= 0) {
      return null;
    }
    String data = await getDataFromBodyInUtf8(request);
    return JSON.decode(data);
  }

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      var json = await getJsonFromBodyInUtf8(
        request,
      );
      Map<String, String> result = ping(
        json,
      );
      request.response.write(result);
      return true;
    }
    match = _routes[1]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      var json = await getJsonFromBodyInUtf8(
        request,
      );
      var result = test(
        request,
        json,
      );
      request.response.write(result);
      return true;
    }
    match = _routes[2]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      var json = await getJsonFromBodyInUtf8(
        request,
      );
      Db mongoDb = await getMongoDbInstance(
        'mongodb://localhost:27017/',
        'test',
      );
      Map<String, String> result = await users.getUser(
        json,
        mongoDb,
      );
      await mongoDb.close();
      request.response.write(result);
      return true;
    }
    match = _routes[3]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      List<int> result = users.getUserWithId(request, args[0],
          toto: request.uri.queryParameters['toto']);
      request.response.write(result);
      return true;
    }
    return false;
  }
}
