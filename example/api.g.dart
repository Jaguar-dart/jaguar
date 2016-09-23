// GENERATED CODE - DO NOT MODIFY BY HAND

part of api;

// **************************************************************************
// Generator: ApiClass
// Target: class ExampleApi
// **************************************************************************

abstract class _$JaguarExampleApi {
  List<RouteInformations> _routes = <RouteInformations>[
    new RouteInformations("/test/v1/ping", ["GET"]),
    new RouteInformations("/test/v1/users/", ["POST"]),
    new RouteInformations("/test/v1/users/([a-zA-Z0-9]+)", ["GET"]),
  ];

  Future<bool> handleApiRequest(HttpRequest request) async {
    List<String> args = <String>[];
    bool match = false;
    match = _routes[0]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      Null result = await get(
        request,
      );
      return true;
    }
    match = _routes[1]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      var json = await _getJsonFromBody(request);
      Map<String, String> result = await users.getUser(
        json,
      );
      String stringifyResult = JSON.encode(result);
      int length = UTF8.encode(stringifyResult).length;
      request.response
        ..headers.add('Content-Type', ContentType.JSON.toString())
        ..contentLength = length
        ..write(stringifyResult);
      return true;
    }
    match = _routes[2]
        .matchWithRequestPathAndMethod(args, request.uri.path, request.method);
    if (match) {
      var json = await _getJsonFromBody(request);
      List<int> result = users.getUserWithId(
        request,
        json,
        args[0],
        toto: request.requestedUri.queryParameters['toto'],
      );
      String stringifyResult = JSON.encode(result);
      int length = UTF8.encode(stringifyResult).length;
      request.response
        ..headers.add('Content-Type', ContentType.JSON.toString())
        ..contentLength = length
        ..write(stringifyResult);
      return true;
    }
    return null;
  }

  Future<dynamic> _getJsonFromBody(HttpRequest request) async {
    mustBeContentType(request, ContentType.JSON);
    if (request.contentLength <= 0) {
      return null;
      throw new BadRequestError('Your json is empty');
    }
    String data = await getUtf8Data(request);
    return JSON.decode(data);
  }

  Future<String> getUtf8Data(HttpRequest request) async {
    Completer<String> completer = new Completer<String>();
    String datas = '';
    request.transform(UTF8.decoder).listen((String data) {
      datas += data;
    },
        onDone: () => completer.complete(datas),
        onError: (dynamic error) => completer.completeError(error));
    return completer.future;
  }

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
}
