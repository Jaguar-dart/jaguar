// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.body.json;

// **************************************************************************
// Generator: ApiGenerator
// Target: class BooksApi
// **************************************************************************

class JaguarBooksApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Post(),
    const Get(path: '/:id'),
    const Delete(path: '/:id'),
    const Put(path: '/:id')
  ];

  final BooksApi _internal;

  factory JaguarBooksApi() {
    final instance = new BooksApi();
    return new JaguarBooksApi.from(instance);
  }
  JaguarBooksApi.from(this._internal);

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api/book';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for addBook
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson;
      DecodeJsonMap iDecodeJsonMap;
      try {
        iEncodeToJson = new WrapEncodeToJson().createInterceptor();
        iDecodeJsonMap = new WrapDecodeJsonMap().createInterceptor();
        Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
          request,
        );
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.addBook(
          rDecodeJsonMap,
        );
        Response<String> rRouteResponse1 = iEncodeToJson.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iDecodeJsonMap?.onException();
        await iEncodeToJson?.onException();
        rethrow;
      }
    }

//Handler for getById
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson;
      try {
        iEncodeToJson = new WrapEncodeToJson().createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.getById(
          (pathParams.getField('id')),
        );
        Response<String> rRouteResponse1 = iEncodeToJson.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeToJson?.onException();
        rethrow;
      }
    }

//Handler for removeBook
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson;
      try {
        iEncodeToJson = new WrapEncodeToJson().createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.removeBook(
          (pathParams.getField('id')),
        );
        Response<String> rRouteResponse1 = iEncodeToJson.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeToJson?.onException();
        rethrow;
      }
    }

//Handler for updateBook
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Map> rRouteResponse0 = new Response(null);
      EncodeToJson iEncodeToJson;
      DecodeJsonMap iDecodeJsonMap;
      try {
        iEncodeToJson = new WrapEncodeToJson().createInterceptor();
        iDecodeJsonMap = new WrapDecodeJsonMap().createInterceptor();
        Map<String, dynamic> rDecodeJsonMap = await iDecodeJsonMap.pre(
          request,
        );
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.headers
            .set('content-type', 'text/plain; charset=utf-8');
        rRouteResponse0.value = _internal.updateBook(
          rDecodeJsonMap,
          (pathParams.getField('id')),
        );
        Response<String> rRouteResponse1 = iEncodeToJson.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iDecodeJsonMap?.onException();
        await iEncodeToJson?.onException();
        rethrow;
      }
    }

    return null;
  }
}
