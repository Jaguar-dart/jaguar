part of jaguar_auth.authenticators;

/// An [Authenticator] for standard username password form style login.
/// It expects a `application/x-www-form-urlencoded` encoded body where the
/// username and password form fields must be called `username` and `password`
/// respectively.
///
/// Arguments:
/// It uses [modelManager] to fetch user model for the authentication request
/// and authenticate against the password
///
/// Outputs ans Variables:
/// The authenticated user model is injected into the context as input
class FormAuth {
  /// Model manager is used to fetch user model for the authentication request
  /// and authenticate against the password
  final AuthModelManager modelManager;

  /// The key by which authorizationId shall be stored in session data
  final String authorizationIdKey;

  /// Specifies whether the interceptor should create/update the session data
  /// on authentication success.
  ///
  /// If set to false, session creation and update must be done manually
  final bool manageSession;

  FormAuth(this.modelManager,
      {this.authorizationIdKey: 'id', this.manageSession: true});

  /// Parses the session from request, fetches the user model and authenticates
  /// it against the password.
  ///
  /// On successful login, injects authenticated user model as context input and
  /// session manager as context variable.
  Future before(Context ctx) async {
    Map<String, String> form = await ctx.bodyAsUrlEncodedForm();

    if (form is! Map<String, String>) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    final String username = form['username'];
    final String password = form['password'];

    if (username is! String) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    if (password is! String) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

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

  static Future<ModelType> authenticate<ModelType extends AuthorizationUser>(
      Context ctx, AuthModelManager modelManager,
      {String authorizationIdKey: 'id', bool manageSession: true}) async {
    Map<String, String> form = await ctx.bodyAsUrlEncodedForm();

    if (form is! Map<String, String>) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    final String username = form['username'];
    final String password = form['password'];

    if (username is! String) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

    if (password is! String) {
      throw new Response(null, statusCode: HttpStatus.UNAUTHORIZED);
    }

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

    return subject;
  }
}
