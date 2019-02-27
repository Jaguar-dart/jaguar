part of jaguar.http.session;

/// A stateless cookie based session manager.
///
/// Stores all session data on a Cookie.
///
/// If [hmacKey] is provided, the sessions data is signed with a signature and
/// verified after parsing.
class JaguarSessionManager implements SessionManager {
  /// Duration after which the session is expired
  final Duration expiry;

  /// Codes, encrypts and signs the session data
  final MapCoder coder;

  final SessionIo io;

  /// Constructs a new [JaguarSessionManager] with given [cookieName], [expiry]
  /// and [signerKey].
  JaguarSessionManager(
      {this.expiry, String signerKey, this.io = const SessionIoCookie()})
      : coder = JaguarMapCoder(
            signer:
                signerKey != null ? Hmac(sha256, signerKey.codeUnits) : null);

  JaguarSessionManager.withCoder(this.coder,
      {this.expiry, this.io = const SessionIoCookie()});

  /// Parses session from the given [request]
  Session parse(Context ctx) {
    String raw = io.read(ctx);
    if (raw == null) return Session.newSession({});
    Map<String, String> values = coder.decode(raw);

    if (values == null) return Session.newSession({});

    if (values['sid'] is! String) return Session.newSession({});

    final String timeStr = values['sct'];
    if (timeStr is! String) return Session.newSession({});

    final int timeMilli = int.tryParse(timeStr);
    if (timeMilli == null) return Session.newSession({});

    final time = DateTime.fromMillisecondsSinceEpoch(timeMilli);

    if (expiry != null) {
      final Duration diff = new DateTime.now().difference(time);
      if (diff > expiry) {
        return new Session.newSession({});
      }
    }

    return Session(values['sid'], values, time);
  }

  /// Writes session data ([session]) to the Response ([resp]) and returns new
  /// response
  void write(Context ctx) {
    if (!ctx.sessionNeedsUpdate) return;

    final Session session = ctx.parsedSession;
    final Map<String, String> values = session.asMap;
    values['sid'] = session.id;
    values['sct'] = session.createdTime.millisecondsSinceEpoch.toString();
    io.write(ctx, coder.encode(values));
  }
}
