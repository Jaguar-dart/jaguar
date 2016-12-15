// GENERATED CODE - DO NOT MODIFY BY HAND

part of test.jaguar.query_params;

// **************************************************************************
// Generator: ApiGenerator
// Target: class QueryParamsExampleApi
// **************************************************************************

abstract class _$JaguarQueryParamsExampleApi implements RequestHandler {
  static const List<RouteBase> routes = const <RouteBase>[
    const Get(path: '/stringParam'),
    const Get(path: '/intParam'),
    const Get(path: '/doubleParam'),
    const Get(path: '/numParam'),
    const Get(path: '/defStringParam'),
    const Get(path: '/defIntParam'),
    const Get(path: '/defDoubleParam'),
    const Get(path: '/defNumParam')
  ];

  String stringParam({String strParam});

  String intParam({int intParam});

  String doubleParam({num doubleParam});

  String numParam({num numParam});

  String defStringParam({String strParam: 'default'});

  String defIntParam({int intParam: 50});

  String defDoubleParam({num doubleParam: 12.75});

  String defDumParam({num numParam: 5.25});

  Future<bool> handleRequest(HttpRequest request, {String prefix: ''}) async {
    prefix += '/api';
    PathParams pathParams = new PathParams();
    bool match = false;
    QueryParams queryParams = new QueryParams(request.uri.queryParameters);

//Handler for stringParam
    match =
        routes[0].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = stringParam(
        strParam: (queryParams.getField('strParam')),
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for intParam
    match =
        routes[1].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = intParam(
        intParam: stringToInt(queryParams.getField('intParam')),
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for doubleParam
    match =
        routes[2].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = doubleParam(
        doubleParam: stringToNum(queryParams.getField('doubleParam')),
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for numParam
    match =
        routes[3].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = numParam(
        numParam: stringToNum(queryParams.getField('numParam')),
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for defStringParam
    match =
        routes[4].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = defStringParam(
        strParam: (queryParams.getField('strParam')) ?? 'default',
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for defIntParam
    match =
        routes[5].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = defIntParam(
        intParam: stringToInt(queryParams.getField('intParam')) ?? 50,
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for defDoubleParam
    match =
        routes[6].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = defDoubleParam(
        doubleParam: stringToNum(queryParams.getField('doubleParam')) ?? 12.75,
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

//Handler for defDumParam
    match =
        routes[7].match(request.uri.path, request.method, prefix, pathParams);
    if (match) {
      Response<String> rRouteResponse0 = new Response(null);
      rRouteResponse0.statusCode = 200;
      rRouteResponse0.value = defDumParam(
        numParam: stringToNum(queryParams.getField('numParam')) ?? 5.25,
      );
      await rRouteResponse0.writeResponse(request.response);
      return true;
    }

    return false;
  }
}
