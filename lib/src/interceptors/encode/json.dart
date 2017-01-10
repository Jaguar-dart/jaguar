part of jaguar.src.interceptors;

/// Interceptor wrapper to write Map or List as JSON response
class WrapEncodeToJson implements RouteWrapper<EncodeToJson> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeToJson({this.id});

  EncodeToJson createInterceptor() => new EncodeToJson();
}

class EncodeToJson extends Interceptor {
  EncodeToJson();

  @InputRouteResponse()
  Response<String> post(Response incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON.encode(incoming.value);
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

/// Interceptor wrapper to write Map as JSON response
class WrapEncodeMapToJson implements RouteWrapper<EncodeMapToJson> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeMapToJson({this.id});

  EncodeMapToJson createInterceptor() => new EncodeMapToJson();
}

class EncodeMapToJson extends Interceptor {
  EncodeMapToJson();

  @InputRouteResponse()
  Response<String> post(Response<Map> incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON.encode(incoming.value);
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

/// Interceptor wrapper to write List as JSON response
class WrapEncodeListToJson implements RouteWrapper<EncodeListToJson> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeListToJson({this.id});

  EncodeListToJson createInterceptor() => new EncodeListToJson();
}

class EncodeListToJson extends Interceptor {
  EncodeListToJson();

  @InputRouteResponse()
  Response<String> post(Response<List> incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON.encode(incoming.value);
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

/// Interceptor wrapper to write [ToJsonable] or List of [ToJsonable] as JSON response
class WrapEncodeJsonable implements RouteWrapper<EncodeJsonable> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeJsonable({this.id});

  EncodeJsonable createInterceptor() => new EncodeJsonable();
}

class EncodeJsonable extends Interceptor {
  EncodeJsonable();

  @InputRouteResponse()
  Response<String> post(Response incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    if (incoming.value is ToJsonable) {
      resp.value = JSON.encode(incoming.value);
    } else if (incoming.value is List<ToJsonable>) {
      resp.value = JSON.encode(
          incoming.value.map((ToJsonable obj) => obj.toJson()).toList());
    }
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

/// Interceptor wrapper to write [ToJsonable] object as JSON response
class WrapEncodeJsonableObject implements RouteWrapper<EncodeJsonableObject> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeJsonableObject({this.id});

  EncodeJsonableObject createInterceptor() => new EncodeJsonableObject();
}

class EncodeJsonableObject extends Interceptor {
  EncodeJsonableObject();

  @InputRouteResponse()
  Response<String> post(Response<ToJsonable> incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON.encode(incoming.value.toJson());
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}

/// Interceptor wrapper to write List of [ToJsonable] as JSON response
class WrapEncodeJsonableList implements RouteWrapper<EncodeJsonableList> {
  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapEncodeJsonableList({this.id});

  EncodeJsonableList createInterceptor() => new EncodeJsonableList();
}

class EncodeJsonableList extends Interceptor {
  EncodeJsonableList();

  @InputRouteResponse()
  Response<String> post(Response<List<ToJsonable>> incoming) {
    Response<String> resp = new Response<String>.cloneExceptValue(incoming);
    resp.value = JSON
        .encode(incoming.value.map((ToJsonable obj) => obj.toJson()).toList());
    resp.headers[HttpHeaders.CONTENT_TYPE] = 'application/json';
    return resp;
  }
}
