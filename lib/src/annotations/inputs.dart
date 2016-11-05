part of jaguar.src.annotations;

/// Defines inputs to an interceptor
class Input {
  final Type resultFrom;

  final String id;

  const Input(this.resultFrom, {this.id});
}

class InputHeader {
  final String key;

  const InputHeader(this.key);
}

class InputHeaders {
  const InputHeaders();
}

class InputCookie {
  final String key;

  const InputCookie(this.key);
}

class InputCookies {
  const InputCookies();
}

/// Dummy annotation used to request injection of Route's result
///
/// Must be only used in post interceptors
class RouteResponse {
  const RouteResponse();
}
