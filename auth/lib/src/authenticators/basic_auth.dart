part of jaguar_auth.authenticators;

/// BasicAuth performs authentication based on
/// [basic authentication](https://en.wikipedia.org/wiki/Basic_access_authentication).
///
/// It expects base64 encoded "username:password" pair in "authorization" header
/// with "Basic" scheme.
///
/// Arguments:
/// It uses [modelManager] to fetch user model for the authentication request
/// and authenticate against the password
///
/// Outputs ans Variables:
/// The authenticated user model is injected into the context as input
class BasicAuth {
  /// Model manager is used to fetch user model for the authentication request
  /// and authenticate against the password
  final AuthModelManager modelManager;

  /// The key by which authorizationId shall be stored in session data
  final String authorizationIdKey;

  /// Specifies whether the interceptor should create/update the session data
  /// on successful authentication.
  ///
  /// If set to false, session creation and update must be done manually
  final bool manageSession;

  BasicAuth(this.modelManager,
      {this.authorizationIdKey: 'id', this.manageSession: true});

  /// Parses the session from request, fetches the user model and authenticates
  /// it against the password.
  ///
  /// On successful login, injects authenticated user model as context input and
  /// session manager as context variable.
  Future before(Context ctx) async {
    String header = ctx.req.headers.value(HttpHeaders.AUTHORIZATION);
    final basic =
        new AuthHeaderItem.fromHeaderBySchema(header, kBasicAuthScheme);

    if (basic == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    final credentials = _decodeCredentials(basic);
    final usernamePassword = credentials.split(':');

    if (usernamePassword.length != 2) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    final String username = usernamePassword[0];
    final String password = usernamePassword[1];

    final subject = await modelManager.authenticate(ctx, username, password);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    if (manageSession is bool && manageSession) {
      final Session session = await ctx.session;
      // Invalidate old session data
      session.clear();
      // Add new session data
      session.addAll(
          <String, String>{authorizationIdKey: subject.authorizationId});
    }

    ctx.addVariable(subject);
  }

  static String _decodeCredentials(AuthHeaderItem authHeader) {
    try {
      return new String.fromCharCodes(
          const Base64Codec.urlSafe().decode(authHeader.credentials));
    } on FormatException catch (_) {
      return '';
    }
  }

  static const kBasicAuthScheme = 'Basic';

  static Future<ModelType> authenticate<ModelType extends AuthorizationUser>(
      Context ctx, AuthModelManager modelManager,
      {String authorizationIdKey: 'id', bool manageSession: true}) async {
    String header = ctx.req.headers.value(HttpHeaders.AUTHORIZATION);
    final basic =
        new AuthHeaderItem.fromHeaderBySchema(header, kBasicAuthScheme);

    if (basic == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    final credentials = _decodeCredentials(basic);
    final usernamePassword = credentials.split(':');

    if (usernamePassword.length != 2) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    final String username = usernamePassword[0];
    final String password = usernamePassword[1];

    final ModelType subject =
        await modelManager.authenticate(ctx, username, password);

    if (subject == null) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    if (manageSession is bool && manageSession) {
      final Session session = await ctx.session;
      // Invalidate old session data
      session.clear();
      // Add new session data
      session.addAll(
          <String, String>{authorizationIdKey: subject.authorizationId});
    }

    return subject;
  }
}
