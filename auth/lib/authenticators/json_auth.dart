part of jaguar_auth.authenticators;

/// An [Authenticator] for standard username password login using ajax requests.
/// It expects a `application/json` encoded body where the
/// username and password fields must be called `username` and `password`
/// respectively.
///
/// Arguments:
/// It uses [userFetcher] to fetch user model for the authentication request
/// and authenticate against the password
///
/// Outputs ans Variables:
/// The authenticated user model is injected into the context as input
class JsonAuth<UserModel extends PasswordUser>
    implements Interceptor<UserModel> {
  /// Model manager is used to fetch user model for the authentication request
  /// and authenticate against the password
  final UserFetcher<UserModel> userFetcher;

  final Hasher hasher;

  /// The key by which authorizationId shall be stored in session data
  final String authorizationIdKey;

  /// Specifies whether the interceptor should create/update the session data
  /// on authentication success.
  ///
  /// If set to false, session creation and update must be done manually
  final bool manageSession;

  const JsonAuth(
      {this.userFetcher,
      this.authorizationIdKey: 'id',
      this.manageSession: true,
      this.hasher: const NoHasher()});

  /// Parses the session from request, fetches the user model and authenticates
  /// it against the password.
  ///
  /// On successful login, injects authenticated user model as context input and
  /// session manager as context variable.
  Future<UserModel> call(Context ctx) async {
    Map<String, dynamic> jsonBody = await ctx.bodyAsJsonMap();

    if (jsonBody == null) throw UnauthorizedException.invalidRequest;

    final String username = jsonBody['username'];
    final String password = jsonBody['password'] ?? '';

    if (username is! String) throw UnauthorizedException.invalidRequest;

    UserFetcher<UserModel> fetcher = userFetcher ?? ctx.userFetchers[UserModel];
    final subject = await fetcher.byAuthenticationId(ctx, username);

    if (subject == null) throw UnauthorizedException.subjectNotFound;

    if (!hasher.verify(password, subject.password))
      throw UnauthorizedException.invalidPassword;

    if (manageSession is bool && manageSession) {
      final Session session = await ctx.session;
      // Invalidate old session data
      session.clear();
      // Add new session data
      session.addAll(
          <String, String>{authorizationIdKey: subject.authorizationId});
    }

    ctx.addVariable(subject);
    return subject;
  }

  static Future<UserModel> authenticate<UserModel extends PasswordUser>(
      Context ctx,
      {UserFetcher<UserModel> userFetcher,
      String authorizationIdKey: 'id',
      bool manageSession: true,
      Hasher hasher: const NoHasher()}) async {
    await new JsonAuth<UserModel>(
            userFetcher: userFetcher,
            authorizationIdKey: authorizationIdKey,
            manageSession: manageSession,
            hasher: hasher)
        .call(ctx);
    return ctx.getVariable<UserModel>();
  }
}
