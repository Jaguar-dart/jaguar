library jaguar.http.session;

import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';

import 'package:jaguar/src/http/context/context.dart';
import 'package:jaguar/src/http/request/request.dart';
import 'package:jaguar/src/http/response/import.dart';

part 'session_on_cookie.dart';

/// A per-request object containing session information of the request
///
/// [id] field uniquely identifies the session.
///
/// [needsUpdate] reflects if the session has been updated during the current
/// request.
///
/// [createdTime] is the time at which the session was created. It can be used
/// to implement expiry of the session.
///
/// [Session] implements subscript operator, allowing session data to be
/// accessed and updated using normal [Map]-like operators and methods.
///
///     session['email'] = email;
///     String name = session['name'];
///
/// In addition, [getInt] and [getDouble] methods can be used to cast the [String]
/// session value to [int] and [double] values respectively.
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
    if (data is Map) _data.addAll(data);
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

  /// Access session value by [key]
  ///
  /// Example:
  ///
  ///     server.get('/api/set/:item', (ctx) async {
  ///       final Session session = await ctx.session;
  ///       final String oldItem = session['item'];
  ///       // ...
  ///     });
  String operator [](@checked String key) => _data[key];

  /// Set session [value] by [key]
  ///
  /// Example:
  ///
  ///     server.get('/api/set/:item', (ctx) async {
  ///       final Session session = await ctx.session;
  ///       session['item'] = ctx.pathParams.item;
  ///       // ...
  ///     });
  operator []=(String key, String value) {
    _data[key] = value;
    needsUpdate = true;
  }

  /// Set session [value] by [key]
  ///
  /// Example:
  ///
  ///     server.get('/api/set/:item', (ctx) async {
  ///       final Session session = await ctx.session;
  ///       session.add('item', ctx.pathParams.item);
  ///       // ...
  ///     });
  void add(String key, String value) {
    _data[key] = value;
    needsUpdate = true;
  }

  /// Set multiple session key:value pairs
  void addAll(Map<String, String> values) {
    _data.addAll(values);
    needsUpdate = true;
  }

  /// Remove a session key:value by [key]
  ///
  /// Example:
  ///
  ///     server.get('/api/set/:item', (ctx) async {
  ///       final Session session = await ctx.session;
  ///       session.remove('item');
  ///       // ...
  ///     });
  String remove(@checked String key) {
    needsUpdate = true;
    return _data.remove(key);
  }

  /// Removes all the session key:value pairs.
  void clear() {
    _data.clear();
    needsUpdate = true;
  }

  /// Returns keys in session store
  Iterable<String> get keys => _data.keys;

  /// Returns a session value as int by [key]. Returns [defaultVal] if the
  /// conversion fails.
  int getInt(String key, [int defaultVal]) {
    final String val = _data[key];

    if (val == null) return defaultVal;

    return int.parse(val, onError: (_) => defaultVal);
  }

  /// Returns a session value as double by [key]. Returns [defaultVal] if the
  /// conversion fails.
  double getDouble(String key, [double defaultVal]) {
    final String val = _data[key];

    if (val == null) return defaultVal;

    return double.parse(val, (_) => defaultVal);
  }

  /// Returns the session data as [Map]
  Map<String, String> get asMap => new Map<String, String>.from(_data);

  /// Random number generator used to create session IDs among other things.
  static final Random rand = new Random();

  /// Returns new Session ID
  static String get newId =>
      new DateTime.now().toUtc().millisecondsSinceEpoch.toString() +
      '-' +
      rand.nextInt(1 << 32).toString();
}

/// Session manager to parse and write session data
abstract class SessionManager {
  /// Parses session from the given [context]
  FutureOr<Session> parse(Context context);

  /// Writes session data ([session]) to the Response ([resp]) and returns new
  /// response
  FutureOr<Response> write(Context ctx, Response resp);
}
