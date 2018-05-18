part of jaguar_cors;

/// CORS options to configure [Cors] Interceptor
class CorsOptions {
  /// Allow all origins
  ///
  /// Under the hood:
  /// Sets 'Access-Control-Allow-Origin: *'
  final bool allowAllOrigins;

  /// The list of origins a cross-domain request can be executed from.
  ///
  /// Setting [allowAllOrigins] to [true] overrides [allowedOrigins] and allows
  /// all origins.
  ///
  /// Example: ['http://example.com', 'http://hello.com']
  ///
  /// Under the hood:
  /// Sets Access-Control-Allow-Origin to list of allowed origins
  final List<String> allowedOrigins;

  /// Indicates whether the request can include user credentials like cookies,
  /// HTTP authentication or client side SSL certificates
  ///
  /// Under the hood:
  /// Sets Access-Control-Allow-Credentials
  final bool allowCredentials;

  /// Allow all methods
  ///
  /// Under the hood:
  /// Sets 'Access-Control-Allow-Methods: *'
  final bool allowAllMethods;

  /// The list of HTTP methods that are allowed
  ///
  /// Under the hood:
  /// Sets Access-Control-Allow-Methods
  final List<String> allowedMethods;

  /// Allow all headers
  ///
  /// Under the hood:
  /// Sets Access-Control-Allow-Headers
  final bool allowAllHeaders;

  /// The HTTP request headers that are allowed
  ///
  /// Under the hood:
  /// Sets Access-Control-Allow-Headers
  final List<String> allowedHeaders;

  /// Expose all headers
  ///
  /// Under the hood:
  /// Sets Access-Control-Allow-Headers
  final bool exposeAllHeaders;

  /// The HTTP response headers that shall be exposed to the client application
  ///
  /// Under the hood:
  /// Sets Access-Control-Allow-Headers
  final List<String> exposeHeaders;

  /// The maximum time (in seconds) to cache the preflight response
  ///
  /// Under the hood:
  /// Sets Access-Control-Max-Age
  final int maxAge;

  final bool vary;

  final allowNonCorsRequests;

  const CorsOptions(
      {this.allowAllOrigins: false,
      this.allowedOrigins: const [],
      this.allowCredentials: false,
      this.allowAllMethods: false,
      this.allowedMethods: const ['GET', 'POST'],
      this.allowAllHeaders: false,
      this.allowedHeaders: const [],
      this.exposeAllHeaders: false,
      this.exposeHeaders: const [],
      this.maxAge,
      this.vary: false,
      this.allowNonCorsRequests: true});
}

/// Internal dummy class to hold header key constants
abstract class _CorsHeaders {
  static const String AllowedOrigin = 'Access-Control-Allow-Origin';

  static const String AllowCredentials = 'Access-Control-Allow-Credentials';

  static const String Vary = 'Vary';

  static const String AllowedMethods = 'Access-Control-Allow-Methods';

  static const String AllowedHeaders = 'Access-Control-Allow-Headers';

  static const String MaxAge = 'Access-Control-Max-Age';

  static const String ExposeHeaders = 'Access-Control-Expose-Headers';

  static const String Origin = 'Origin';

  static const String RequestMethod = 'Access-Control-Request-Method';

  static const String RequestHeaders = 'Access-Control-Request-Headers';
}
