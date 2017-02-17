part of jaguar.src.interceptors;

class WrapDecodeJsonMap extends RouteWrapper<DecodeJsonMap> {
  final Encoding encoding;

  final String id;

  const WrapDecodeJsonMap({this.encoding: UTF8, this.id});

  DecodeJsonMap createInterceptor() => new DecodeJsonMap(encoding: encoding);
}

class DecodeJsonMap extends Interceptor {
  final Encoding encoding;

  DecodeJsonMap({this.encoding: UTF8});

  Future<Map<String, dynamic>> pre(Request request) async {
    String data = await request.bodyAsText(encoding);
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
