/// Declares the Jaguar `Context` class
library jaguar.src.http.context;

import 'dart:collection';

import 'package:quiver_hashcode/hashcode.dart' show hash2;
import 'package:jaguar/jaguar.dart';
import 'package:logging/logging.dart';

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

/// Request context
///
/// Contains:
/// 1. Request object
/// 2. Path parameters
/// 3. Query parameters
/// 4. Route inputs
/// 5. Route variables
/// 6. Interceptors
class Context {
  Uri get uri => req.uri;

  String get path => uri.path;

  String get method => req.method;

  /// Request
  final Request req;

  /// Path parameters
  final PathParams pathParams = new PathParams();

  QueryParams _queryParams;

  /// Returns query params for the request
  ///
  /// Lazily creates query parameters to enhance performance of route handling
  QueryParams get queryParams {
    if (_queryParams != null) return _queryParams;

    _queryParams = new QueryParams(req.uri.queryParameters);
    return _queryParams;
  }

  /// Interceptors for the route
  final _interceptorCreators = <InterceptorCreator>[];

  UnmodifiableListView<InterceptorCreator> get interceptorCreators =>
      new UnmodifiableListView<InterceptorCreator>(_interceptorCreators);

  final _inputs = <_IdiedType, dynamic>{};

  final _variables = <_IdiedType, dynamic>{};

  Context(this.req);

  Logger get log => req.log;

  void addInterceptor(InterceptorCreator interceptor) =>
      _interceptorCreators.add(interceptor);

  void addInterceptors(Iterable<InterceptorCreator> interceptors) =>
      _interceptorCreators.addAll(interceptors);

  /// Gets input by [Interceptor] and [id]
  T getInput<T>(Type interceptor, {String id}) {
    final idied = new _IdiedType(interceptor, id: id);
    // Throw if the requested interceptor has not been executed yet
    if (!_inputs.containsKey(idied)) {
      throw new Exception(
          "Context does not have output from an interceptor of type:$interceptor and id:$id!");
    }
    final ret = _inputs[idied];
    // TODO[teja] change to `ret is! T` when Dart supports reified generic types
    return ret as T;
  }

  /// Adds output of an Interceptor by id
  void addOutput(
      Type interceptorType, String id, Interceptor interceptor, dynamic value) {
    final idied = new _IdiedType(interceptorType, id: id);
    if (_inputs.containsKey(idied)) {
      throw new Exception(
          "Context already has output from an interceptor of type:$interceptorType and id:$id!");
    }
    _inputs[idied] = value;
  }

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
