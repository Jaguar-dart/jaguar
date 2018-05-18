part of jaguar_cors;

/// Internal structure that holds CORS headers parsed from request
class _CorsRequestParams {
  /// Holds value of 'Origin' header in request
  final String origin;

  /// Holds value of 'Access-Control-Request-Method' header in request
  final String method;

  /// Holds value of 'Access-Control-Request-Headers' header in request
  final List<String> headers;

  /// Returns if the request is a CORS request
  ///
  /// A request is a CORS request if it has 'Origin' header
  bool get isCors => origin is String;

  _CorsRequestParams._(this.origin, this.method, this.headers);

  /// Parses CORS headers from request [req]
  factory _CorsRequestParams.fromRequest(Request req) {
    final String origin = req.headers.value(_CorsHeaders.Origin);

    if (origin is! String) return new _CorsRequestParams._(null, null, null);

    String method;
    {
      dynamic value = req.headers.value(_CorsHeaders.RequestMethod);
      if (value is String) {
        method = value;
      }
    }

    final List<String> headers = [];
    {
      dynamic value = req.headers.value(_CorsHeaders.RequestHeaders);
      if (value is String) {
        headers.addAll(value.split(','));
      }
    }

    return new _CorsRequestParams._(origin, method, headers);
  }
}
