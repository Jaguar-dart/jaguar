part of jaguar.src.interceptors;

class EncodeToJson extends Interceptor {
  const EncodeToJson();

  @InputRouteResponse()
  Response pre(Response resp) {
    resp.value = JSON.encode(resp.value);
    return resp;
  }
}
