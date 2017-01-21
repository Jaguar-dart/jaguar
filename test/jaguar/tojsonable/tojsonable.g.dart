// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.query_params;

// **************************************************************************
// Generator: ApiGenerator
// Target: class ToJsonableExampleApi
// **************************************************************************

abstract class _$JaguarToJsonableExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/EncodeJsonable/object'),
    const Get(path: '/EncodeJsonable/list'),
    const Get(path: '/EncodeJsonableObject'),
    const Get(path: '/EncodeJsonableList')
  ];

  Model encodeJsonable_object();

  List<Model> encodeJsonable_list();

  Model encodeJsonableObject();

  List<Model> encodeJsonableList();

  Future<Response> handleRequest(Request request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;

//Handler for encodeJsonable_object
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Model> rRouteResponse0 = new Response(null);
      EncodeJsonable iEncodeJsonable;
      try {
        iEncodeJsonable = new WrapEncodeJsonable().createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = encodeJsonable_object();
        Response<String> rRouteResponse1 = iEncodeJsonable.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonable?.onException();
        rethrow;
      }
    }

//Handler for encodeJsonable_list
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      EncodeJsonable iEncodeJsonable;
      try {
        iEncodeJsonable = new WrapEncodeJsonable().createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = encodeJsonable_list();
        Response<String> rRouteResponse1 = iEncodeJsonable.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonable?.onException();
        rethrow;
      }
    }

//Handler for encodeJsonableObject
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<Model> rRouteResponse0 = new Response(null);
      EncodeJsonableObject iEncodeJsonableObject;
      try {
        iEncodeJsonableObject =
            new WrapEncodeJsonableObject().createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = encodeJsonableObject();
        Response<String> rRouteResponse1 = iEncodeJsonableObject.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonableObject?.onException();
        rethrow;
      }
    }

//Handler for encodeJsonableList
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<List> rRouteResponse0 = new Response(null);
      EncodeJsonableList iEncodeJsonableList;
      try {
        iEncodeJsonableList = new WrapEncodeJsonableList().createInterceptor();
        rRouteResponse0.statusCode = 200;
        rRouteResponse0.setContentType('text/plain; charset=us-ascii');
        rRouteResponse0.value = encodeJsonableList();
        Response<String> rRouteResponse1 = iEncodeJsonableList.post(
          rRouteResponse0,
        );
        return rRouteResponse1;
      } catch (e) {
        await iEncodeJsonableList?.onException();
        rethrow;
      }
    }

    return null;
  }
}
