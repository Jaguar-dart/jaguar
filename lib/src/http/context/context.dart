/// Declares the Jaguar `Context` class
library jaguar.src.http.context;

import 'dart:async';

import 'package:jaguar/jaguar.dart';
import 'package:logging/logging.dart';

/// Per-request context object
///
/// Contains:
/// 1. Request object
/// 2. Path parameters
/// 3. Query parameters
/// 4. Route inputs
/// 5. Route variables
/// 6. Interceptors
/// 7. Session object
class Context {
  /// Uri of the HTTP request
  Uri get uri => req.uri;

  /// Path of the HTTP request
  String get path => uri.path;

  /// Path segments of the HTTP request
  List<String> get pathSegments => uri.pathSegments;

  /// Method of the HTTP request
  String get method => req.method;

  /// [Request] object of the current HTTP request.
  ///
  /// Example:
  ///
  ///     final server = new Jaguar();
  ///     server.post('/api/book', (Context ctx) async {
  ///       // Decode request body as JSON Map
  ///       final List json = await ctx.req.bodyAsJsonList();
  ///       // ...
  ///     });
  ///     await server.serve();
  final Request req;

  /// Path parameters
  ///
  /// Example:
  ///
  ///     server.get('/api/quote/:index', (ctx) { // The magic!
  ///       final int index = ctx.pathParams.getInt('index', 1);  // The magic!
  ///       return quotes[index + 1];
  ///     });
  final PathParams pathParams = new PathParams();

  QueryParams _query;

  /// Returns query parameters of the request
  ///
  /// Lazily creates query parameters to enhance performance of route handling.
  ///
  /// Example:
  ///
  ///     server.get('/api/quote', (ctx) {
  ///       final int index = ctx.query.getInt('index', 1); // The magic!
  ///       return quotes[index + 1];
  ///     });
  QueryParams get query {
    if (_query != null) return _query;

    _query = new QueryParams(req.uri.queryParameters);
    return _query;
  }

  final SessionManager _sessionManager;

  Session _session;

  /// Does the session need update?
  bool get sessionNeedsUpdate => _session != null && _session.needsUpdate;

  /// Parsed session. Returns null, if the session is not parsed yet.
  Session get parsedSession => _session;

  /// The session for the given request.
  ///
  /// Example:
  ///
  ///     server.get('/api/set/:item', (ctx) async {
  ///       final Session session = await ctx.req.session;
  ///       session['item'] = ctx.pathParams.item;
  ///       // ...
  ///     });
  Future<Session> get session async {
    if (_session == null) {
      _session = await _sessionManager.parse(this);
    }
    return this._session;
  }

  final List<String> debugMsgs = <String>[];

  Context(this.req, this._sessionManager);

  Logger get log => req.log;

  final _interceptorResults = <Type, Map<String, Interceptor>>{};

  /// Gets interceptor result by [Interceptor] and [id]
  T getInterceptorResult<T>(Type interceptor, {String id}) =>
      getInterceptor(interceptor, id: id)?.output;

  /// Gets interceptor by [Interceptor] and [id]
  Interceptor getInterceptor(Type interceptor, {String id}) {
    Map<String, dynamic> map = _interceptorResults[interceptor];
    if(map == null) return null;
    return map[id];
  }

  /// Adds output of an Interceptor by id
  void addInterceptor(
      Type interceptorType, String id, Interceptor interceptor) {
    if (!_interceptorResults.containsKey(interceptorType)) {
      _interceptorResults[interceptorType] = {id: interceptor};
    } else {
      _interceptorResults[interceptorType][id] = interceptor;
    }
  }

  final _variables = <Type, Map<String, dynamic>>{};

  /// Gets variable by type and id
  T getVariable<T>({String id}) {
    Map<String, dynamic> map = _variables[T];
    if(map == null) return null;
    return map[id];
  }

  /// Adds variable by type and id
  void addVariable<T>(T value, {String id}) {
    if (!_variables.containsKey(value.runtimeType)) {
      _variables[value.runtimeType] = {id: value};
    } else {
      _variables[value.runtimeType][id] = value;
    }
  }
}
