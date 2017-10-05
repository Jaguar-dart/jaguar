library jaguar.src.http.session;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:meta/meta.dart';

import 'package:jaguar/src/http/request/request.dart';
import 'package:jaguar/src/http/response/import.dart';

/// A session
class Session extends Object with MapMixin<String, String> {
  /// Session ID
  ///
  /// Do not use this
  final String id;

  /// Session data
  final Map<String, String> data = <String, String>{};

  /// Indicates whether session is newly created
  final bool isNew;

  /// CreatedTime is when the session was created
  final DateTime createdTime;

  Session(this.id, Map<String, String> data, this.createdTime,
      {this.isNew: false}) {
    if (data is Map) addAll(data);
  }

  // TODO create unique id
  Session.newSession(Map<String, String> data,
      {String id, DateTime createdTime})
      : id = id ?? '1',
        isNew = true,
        createdTime = createdTime ?? new DateTime.now() {
    if (data is Map) addAll(data);
  }

  String operator [](@checked String key) => data[key];

  operator []=(String key, String value) => data[key] = value;

  String remove(@checked String key) => data.remove(key);

  void clear() => data.clear();

  Iterable<String> get keys => data.keys;

  int getInt(String key, [int defaultVal]) {
    final String val = data[key];

    if (val == null) return defaultVal;

    return int.parse(val, onError: (_) => defaultVal);
  }

  double getDouble(String key, [double defaultVal]) {
    final String val = data[key];

    if (val == null) return defaultVal;

    return double.parse(val, (_) => defaultVal);
  }
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
/// TODO add more details
/// TODO add details about signature and encryption
class CookieSessionManager implements SessionManager {
  /// Name of the cookie on which session data is stored
  final String cookieName;

  /// Duration after which the session is expired
  final Duration expiry;

  CookieSessionManager({this.cookieName = 'session', this.expiry});

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
  Future<Response> write(Request request, Response resp) async {
    final session = await request.session;
    final values = new Map<String, String>.from(session);
    values['sid'] = session.id;
    values['sct'] = session.createdTime.millisecondsSinceEpoch.toString();
    final cook = new Cookie(cookieName, _encode(values));
    resp.cookies.add(cook);
    return resp;
  }

  String _encode(Map<String, String> values) {
    String str = JSON.encode(values);
    // TODO encrypt
    return const Base64Codec.urlSafe().encode(str.codeUnits);
  }

  dynamic _decode(String data) {
    String str =
        new String.fromCharCodes(const Base64Codec.urlSafe().decode(data));
    // TODO decrypt
    return JSON.decode(str);
  }
}
