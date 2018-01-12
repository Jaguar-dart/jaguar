/// Declares the Jaguar `Context` class
library jaguar.src.http.context;

import 'dart:collection';
import 'dart:async';

import 'package:quiver_hashcode/hashcode.dart' show hash2;
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

  /// Interceptors for the route
  final _interceptorCreators = <InterceptorCreator>[];

  UnmodifiableListView<InterceptorCreator> get interceptorCreators =>
      new UnmodifiableListView<InterceptorCreator>(_interceptorCreators);

  final List<String> debugMsgs = <String>[];

  Context(this.req, this._sessionManager);

  Logger get log => req.log;

  void addInterceptor(InterceptorCreator interceptor) =>
      _interceptorCreators.add(interceptor);

  void addInterceptors(Iterable<InterceptorCreator> interceptors) =>
      _interceptorCreators.addAll(interceptors);

  final _interceptorResults = <_IdiedType, dynamic>{};

  /// Gets interceptor result by [Interceptor] and [id]
  T getInterceptorResult<T>(Type interceptor, {String id}) {
    final idied = new _IdiedType(interceptor, id: id);
    // Throw if the requested interceptor has not been executed yet
    if (!_interceptorResults.containsKey(idied)) {
      throw new Exception(
          "Context does not have output from an interceptor of type:$interceptor and id:$id!");
    }
    final ret = _interceptorResults[idied];
    // TODO[teja] change to `ret is! T` when Dart supports reified generic types
    return ret as T;
  }

  /// Adds output of an Interceptor by id
  void addInterceptorResult(
      Type interceptorType, String id, Interceptor interceptor, dynamic value) {
    final idied = new _IdiedType(interceptorType, id: id);
    if (_interceptorResults.containsKey(idied)) {
      throw new Exception(
          "Context already has output from an interceptor of type:$interceptorType and id:$id!");
    }
    _interceptorResults[idied] = value;
  }

  final _variables = <_IdiedType, dynamic>{};

  /// Gets variable by type and id
  T getVariable<T>({String id}) {
    final idied = new _IdiedType(T, id: id);
    // Throw if the variable is not present
    if (!_variables.containsKey(idied)) {
      throw new Exception(
          "Context does not have variable of type:$T and id:$id!");
    }
    return _variables[idied];
  }

  /// Adds variable by type and id
  void addVariable<T>(T value, {String id}) {
    final idied = new _IdiedType(T, id: id);
    if (_variables.containsKey(idied)) {
      throw new Exception(
          "Context already has variable of type:$T and id:$id!");
    }
    _variables[idied] = value;
  }
}

class _IdiedType {
  final Type interceptor;

  final String id;

  const _IdiedType(this.interceptor, {this.id});

  @override
  int get hashCode => hash2(interceptor, id);

  @override
  bool operator ==(final other) {
    if (other is! _IdiedType) return false;

    return interceptor == other.interceptor && id == other.id;
  }
}
