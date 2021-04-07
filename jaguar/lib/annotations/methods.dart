part of jaguar.src.annotations;

typedef String WsResultProcessor(dynamic response);

/// Function that modifies [context]
typedef FutureOr<void> ResponseProcessor(Context context, dynamic result);

/// [ResponseProcessor] to encode response value to json and also set mimetype
/// to [MimeType.json].
void jsonResponseProcessor(Context context, dynamic result) {
  final info = context.route?.info;

  final codec = context.codecFor(mimeType: MimeTypes.json);
  if (codec != null) {
    result = codec.to(result);
  }

  context.response = Response.json(result,
      statusCode: info?.statusCode ?? 200,
      mimeType: info?.mimeType ?? MimeTypes.json,
      charset: info?.charset ?? kDefaultCharset);
}

///An annotation to define a route
class HttpMethod {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods;

  /// Map of regular expression matchers for specific path segment
  final Map<String, String>? pathRegEx;

  final int statusCode;

  final String? mimeType;

  final String? charset;

  final ResponseProcessor? responseProcessor;

  const HttpMethod(
      {this.path = '',
      this.methods = _methods,
      this.pathRegEx,
      this.statusCode = 200,
      this.mimeType,
      this.charset,
      this.responseProcessor});

  static const List<String> _methods = const <String>['*'];

  String toString() => '$methods $path';

  HttpMethod cloneWith(
          {String? path,
          List<String>? methods,
          Map<String, String>? pathRegEx,
          int? statusCode,
          String? mimeType,
          String? charset,
          ResponseProcessor? responseProcessor}) =>
      HttpMethod(
          path: path ?? this.path,
          methods: methods ?? this.methods,
          pathRegEx: pathRegEx ?? this.pathRegEx,
          statusCode: statusCode ?? this.statusCode,
          mimeType: mimeType ?? this.mimeType,
          charset: charset ?? this.charset,
          responseProcessor: responseProcessor ?? this.responseProcessor);
}

const String kDefaultMimeType = 'text/plain';
const String kDefaultCharset = 'utf-8';

abstract class WsAnnot implements HttpMethod {
  RouteHandler makeHandler(WsOnConnect onConnect);
}

class WsStream implements WsAnnot {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods = _methods;

  /// Map of regular expression matchers for specific path segment
  final Map<String, String>? pathRegEx;

  final int statusCode;

  final String? mimeType;

  final String? charset;

  final ResponseProcessor? responseProcessor;

  const WsStream(
      {this.path = '',
      this.pathRegEx,
      this.statusCode = 200,
      this.mimeType,
      this.charset = kDefaultCharset,
      this.responseProcessor});

  HttpMethod cloneWith(
          {String? path,
          List<String>? methods,
          Map<String, String>? pathRegEx,
          int? statusCode,
          String? mimeType,
          String? charset,
          ResponseProcessor? responseProcessor}) =>
      HttpMethod(
          path: path ?? this.path,
          methods: methods ?? this.methods,
          pathRegEx: pathRegEx ?? this.pathRegEx,
          statusCode: statusCode ?? this.statusCode,
          mimeType: mimeType ?? this.mimeType,
          charset: charset ?? this.charset,
          responseProcessor: responseProcessor ?? this.responseProcessor);

  RouteHandler makeHandler(WsOnConnect onConnect) => wsStream(onConnect);

  static const List<String> _methods = const <String>['GET'];
}

class WsRespond implements WsAnnot {
  /// Path of the route
  final String path;

  /// Methods handled by the route
  final List<String> methods = _methods;

  /// Map of regular expression matchers for specific path segment
  final Map<String, String>? pathRegEx;

  final int statusCode;

  final String? mimeType;

  final String? charset;

  final ResponseProcessor? responseProcessor;

  const WsRespond(
      {this.path = '',
      this.pathRegEx,
      this.statusCode = 200,
      this.mimeType,
      this.charset = kDefaultCharset,
      this.responseProcessor});

  HttpMethod cloneWith(
          {String? path,
          List<String>? methods,
          Map<String, String>? pathRegEx,
          int? statusCode,
          String? mimeType,
          String? charset,
          ResponseProcessor? responseProcessor}) =>
      HttpMethod(
          path: path ?? this.path,
          methods: methods ?? this.methods,
          pathRegEx: pathRegEx ?? this.pathRegEx,
          statusCode: statusCode ?? this.statusCode,
          mimeType: mimeType ?? this.mimeType,
          charset: charset ?? this.charset,
          responseProcessor: responseProcessor ?? this.responseProcessor);

  RouteHandler makeHandler(WsOnConnect onConnect) => wsRespond(onConnect);

  static const List<String> _methods = const <String>['GET'];
}
