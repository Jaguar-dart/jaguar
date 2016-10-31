library jaguar.src.http.response;

class Response<ValueType> {
  final ValueType value;

  final int statusCode;

  final Map<String, String> headers;

  Response(this.value, {this.statusCode: 200, this.headers});

  String get valueAsString => value?.toString() ?? '';
}
