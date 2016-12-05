part of jaguar.src.interceptors;

class DecodeJson extends Interceptor {
  final Encoding encoding;

  const DecodeJson({this.encoding: UTF8});

  Future<dynamic> pre(HttpRequest request) async {
    String data = await getStringFromBody(request, encoding);
    if (data.isNotEmpty) {
      return JSON.decode(data);
    }
    return null;
  }
}

class DecodeJsonMap extends Interceptor {
  final Encoding encoding;

  const DecodeJsonMap({this.encoding: UTF8});

  Future<Map> pre(HttpRequest request) async {
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

class DecodeJsonList extends Interceptor {
  final Encoding encoding;

  const DecodeJsonList({this.encoding: UTF8});

  Future<List> pre(HttpRequest request) async {
    String data = await getStringFromBody(request, encoding);
    if (data.isNotEmpty) {
      dynamic ret = JSON.decode(data);
      if (ret is! List) {
        throw new FormatException('List expect, ${ret.runtimeType} found!');
      }

      return ret;
    }

    return null;
  }
}
