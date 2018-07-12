part of jaguar.http.session;

/// A stateless cookie based session manager.
///
/// Stores all session data on a Cookie.
///
/// If [hmacKey] is provided, the sessions data is signed with a signature and
/// verified after parsing.
class CookieSessionManager implements SessionManager {
  /// Name of the cookie on which session data is stored
  final String cookieName;

  /// Duration after which the session is expired
  final Duration expiry;

  final MapCoder coder;

  /// Constructs a new [CookieSessionManager] with given [cookieName], [expiry]
  /// and [signerKey].
  CookieSessionManager(
      {this.cookieName = 'session', this.expiry, String signerKey})
      : coder = MapCoder(
            signer:
                signerKey != null ? Hmac(sha256, signerKey.codeUnits) : null);

  CookieSessionManager.withCoder(this.coder,
      {this.cookieName = 'session', this.expiry, String hmacKey});

  /// Parses session from the given [request]
  Session parse(Context ctx) {
    Map<String, String> values;
    for (Cookie cook in ctx.req.cookies) {
      if (cook.name == cookieName) {
        dynamic valueMap = coder.decode(cook.value);
        if (valueMap is Map<String, String>) {
          values = valueMap;
        }
        break;
      }
    }

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
    final cook = Cookie(cookieName, coder.encode(values));
    cook.path = '/';
    ctx.response.cookies.add(cook);
  }
}

/// Encodes and decodes a session data
class MapCoder {
  final Codec<String, String> encrypter;

  /// The signer
  final Converter<List<int>, Digest> signer;

  MapCoder({this.signer, this.encrypter});

  /// Encodes the session values
  String encode(Map<String, String> values) {
    // Map data to String
    String value = json.encode(values);
    // Encrypt the data
    if (encrypter != null) value = encrypter.encode(value);
    // Base64 URL safe encoding
    String ret = base64UrlEncode(value.codeUnits);
    if (signer == null) return ret;
    // Sign it!
    return ret + '.' + base64UrlEncode(signer.convert(ret.codeUnits).bytes);
  }

  Map<String, String> decode(String data) {
    if (signer != null) {
      List<String> parts = data.split('.');
      if (parts.length != 2) return null;

      try {
        if (base64Url.encode(signer.convert(parts[0].codeUnits).bytes) !=
            parts[1]) return null;
      } catch (e) {
        return null;
      }

      data = parts[0];
    }

    try {
      String value = String.fromCharCodes(base64Url.decode(data));
      if (encrypter != null) value = encrypter.decode(value);
      Map values = json.decode(value);
      return values.cast<String, String>();
    } catch (e) {
      return null;
    }
  }
}
