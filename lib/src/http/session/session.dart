library jaguar.src.http.session;

import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';

import 'package:jaguar/src/http/request/request.dart';
import 'package:jaguar/src/http/response/import.dart';

/// A per request object containing session information of the request
///
/// [id] field uniquely identifies the session.
/// [needsUpdate] reflects if the session is creates during the current request.
/// [createdTime] is the time at which the session was created. It can be used
/// to implement expiry of the session.
///
/// [Session] implements a [Map<String, String>] interface. The session data
/// can be obtained and manipulated using normal [Map] operators and methods.
///
///     session['email'] = email;
///     String name = session['name'];
///
/// In addition, [getInt] and [getDouble] methods can be used to cast the [String]
/// session value to [int] and [double] respectively.
class Session {
  /// Session ID
  final String id;

  /// Session data
  final Map<String, String> _data = <String, String>{};

  /// Indicates whether session needs update
  bool needsUpdate = false;

  /// CreatedTime is when the session was created
  final DateTime createdTime;

  /// Creates a session object for existing session with given [data], [id] and
  /// [createdTime]
  Session(this.id, Map<String, String> data, this.createdTime,
      {this.needsUpdate: false}) {
    if (data is Map) addAll(data);
  }

  /// Create new session with given [data], [id] and [createdTime]
  ///
  /// If [id] is not given, it tries to create a new unique id.
  /// If [createdTime] is not given, it sets the [createdTime] to current time
  Session.newSession(Map<String, String> data,
      {String id, DateTime createdTime})
      : id = id ?? newId,
        needsUpdate = true,
        createdTime = createdTime ?? new DateTime.now() {
    if (data is Map) _data.addAll(data);
  }

  String operator [](@checked String key) => _data[key];

  operator []=(String key, String value) {
    _data[key] = value;
    needsUpdate = true;
  }

  void add(String key, String value) {
    _data[key] = value;
    needsUpdate = true;
  }

  void addAll(Map<String, String> values) {
    _data.addAll(values);
    needsUpdate = true;
  }

  String remove(@checked String key) {
    needsUpdate = true;
    return _data.remove(key);
  }

  void clear() {
    _data.clear();
    needsUpdate = true;
  }

  Iterable<String> get keys => _data.keys;

  /// Returns a session value as int
  int getInt(String key, [int defaultVal]) {
    final String val = _data[key];

    if (val == null) return defaultVal;

    return int.parse(val, onError: (_) => defaultVal);
  }

  /// Returns a session value as double
  double getDouble(String key, [double defaultVal]) {
    final String val = _data[key];

    if (val == null) return defaultVal;

    return double.parse(val, (_) => defaultVal);
  }

  Map<String, String> get asMap => new Map<String, String>.from(_data);

  static final Random rand = new Random();

  static String get newId =>
      new DateTime.now().toUtc().millisecondsSinceEpoch.toString() +
      '-' +
      rand.nextInt(1 << 32).toString();
}

/// Session manager to parse and write session data
abstract class SessionManager {
  /// Parses session from the given [request]
  FutureOr<Session> parse(Request request);

  /// Writes session data ([session]) to the Response ([resp]) and returns new
  /// response
  FutureOr<Response> write(Request request, Response resp);
}

/// A stateless cookie based session manager
///
/// Stores all session data on a Cookie
///
/// If [hmacKey] is provided, the sessions data is signed with a signature and
/// verified after parsed.
class CookieSessionManager implements SessionManager {
  /// Name of the cookie on which session data is stored
  final String cookieName;

  /// Duration after which the session is expired
  final Duration expiry;

  CookieSessionManager(
      {this.cookieName = 'session', this.expiry, String hmacKey})
      : _encrypter =
            hmacKey != null ? new Hmac(sha256, hmacKey.codeUnits) : null;

  /// Parses session from the given [request]
  Session parse(Request request) {
    Map<String, String> values;
    for (Cookie cook in request.cookies) {
      if (cook.name == cookieName) {
        dynamic valueMap = _decode(cook.value);
        if (valueMap is Map<String, String>) {
          values = valueMap;
        }
        break;
      }
    }

    if (values == null) {
      return new Session.newSession({});
    }

    if (values['sid'] is! String) {
      return new Session.newSession({});
    }

    final String timeStr = values['sct'];
    if (timeStr is! String) {
      return new Session.newSession({});
    }

    final int timeMilli = int.parse(timeStr, onError: (_) => null);
    if (timeMilli == null) {
      return new Session.newSession({});
    }

    final time = new DateTime.fromMillisecondsSinceEpoch(timeMilli);

    if (expiry != null) {
      final Duration diff = new DateTime.now().difference(time);
      if (diff > expiry) {
        return new Session.newSession({});
      }
    }

    return new Session(values['sid'], values, time);
  }

  /// Writes session data ([session]) to the Response ([resp]) and returns new
  /// response
  Response write(Request request, Response resp) {
    if (!request.sessionNeedsUpdate) return resp;

    final Session session = request.parsedSession;
    final Map<String, String> values = session.asMap;
    values['sid'] = session.id;
    values['sct'] = session.createdTime.millisecondsSinceEpoch.toString();
    final cook = new Cookie(cookieName, _encode(values));
    cook.path = '/';
    resp.cookies.add(cook);
    return resp;
  }

  String _encode(Map<String, String> values) {
    // Base64 URL safe encoding
    String ret = BASE64URL.encode(JSON.encode(values).codeUnits);
    // If there is no encrypter, skip signature
    if (_encrypter == null) return ret;
    return ret +
        '.' +
        BASE64URL.encode(_encrypter.convert(ret.codeUnits).bytes);
  }

  Map<String, String> _decode(String data) {
    if (_encrypter == null) {
      try {
        return JSON.decode(new String.fromCharCodes(BASE64URL.decode(data)));
      } catch (e) {
        return null;
      }
    } else {
      List<String> parts = data.split('.');
      if (parts.length != 2) return null;
      try {
        if (BASE64URL.encode(_encrypter.convert(parts.first.codeUnits).bytes) !=
            parts[1]) return null;

        return JSON
            .decode(new String.fromCharCodes(BASE64URL.decode(parts.first)));
      } catch (e) {
        return null;
      }
    }
  }

  final Hmac _encrypter;
}
