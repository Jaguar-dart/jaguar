part of jaguar.src.interceptors;

class WrapDecodeJsonMap implements RouteWrapper<DecodeJsonMap> {
  final Encoding encoding;

  final String id;

  final Map<Symbol, MakeParam> makeParams = const {};

  const WrapDecodeJsonMap({this.encoding: UTF8, this.id});

  DecodeJsonMap createInterceptor() => new DecodeJsonMap(encoding: encoding);
}

class DecodeJsonMap extends Interceptor {
  final Encoding encoding;

  DecodeJsonMap({this.encoding: UTF8});

  Future<Map<String, dynamic>> pre(HttpRequest request) async {
    String data = await getStringFromBody(request, encoding);
    if (data.isNotEmpty) {
      dynamic ret = JSON.decode(data);
      if (ret is! Map) {
        throw new FormatException('Map expect, ${ret.runtimeType} found!');
      }

      return ret;
    }

    return null;
  }
}
