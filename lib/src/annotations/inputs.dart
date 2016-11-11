part of jaguar.src.annotations;

/// Annotation to request inputs from another interceptor in request chain
class Input {
  /// Defines an interceptor, whose response must be used as input
  final Type resultFrom;

  /// Identifier to identify an interceptor from interceptors of same type
  final String id;

  const Input(this.resultFrom, {this.id});
}

/// Annotation to request input of Http header
class InputHeader {
  /// Key of the header
  final String key;

  const InputHeader(this.key);
}

/// Annotation to request input of Http headers
class InputHeaders {
  const InputHeaders();
}

/// Annotation to request input of cookie
class InputCookie {
  /// Key of the cookie
  final String key;

  const InputCookie(this.key);
}

/// Annotation to request input of cookies
class InputCookies {
  const InputCookies();
}

/// Dummy interceptor used to request injection of Route's result
///
/// Must be only used in post interceptors
class RouteResponse {
  const RouteResponse();
}

class InputPathParams {
  const InputPathParams();
}

class InputQueryParams {
  const InputQueryParams();
}