library jaguar.src.http.context;

import 'package:quiver_hashcode/hashcode.dart' show hash2;
import 'package:jaguar/jaguar.dart';

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

//TODO add hashcode and equality
}

abstract class Context {
  Request get req;

  PathParams get pathParams;

  QueryParams get queryParams;

  dynamic getInput(Type interceptor, {String id});

  T getVariable<T>({String id});

  void addVariable<T>(T value, {String id});
}

class ContextImpl implements Context {
  final Request req;

  final PathParams pathParams;

  QueryParams get queryParams => null; //TODO

  final List<Interceptor> interceptors = [];

  final _inputs = <_IdiedType, dynamic>{};

  final _variables = <_IdiedType, dynamic>{};

  ContextImpl(this.req, this.pathParams);

  dynamic getInput(Type interceptor, {String id}) {
    /* TODO how to do this?
    // Throw if [interceptor] is not an interceptor
    if (interceptor ) {
      throw new Exception("$interceptor is not a Jaguar interceptor!");
    }
    */
    final idied = new _IdiedType(interceptor, id: id);
    // Throw if the requested interceptor has not been executed yet
    if (!_inputs.containsKey(idied)) {
      throw new Exception(
          "Context does not have output from an interceptor of type:$interceptor and id:$id!");
    }
    return _inputs[idied];
  }

  void addOutput(RouteWrapper rw, Interceptor interceptor, dynamic value) {
    final idied = new _IdiedType(rw.interceptorType, id: rw.id);
    if (_inputs.containsKey(idied)) {
      throw new Exception(
          "Context already has output from an interceptor of type:${rw.interceptorType} and id:${rw.id}!");
    }
    interceptors.add(interceptor);
    _inputs[idied] = value;
  }

  T getVariable<T>({String id}) {
    final idied = new _IdiedType(T, id: id);
    // Throw if the variable is not present
    if (!_inputs.containsKey(idied)) {
      throw new Exception(
          "Context does not have variable of type:$T and id:$id!");
    }
    return _inputs[idied];
  }

  void addVariable<T>(T value, {String id}) {
    final idied = new _IdiedType(T, id: id);
    if (_variables.containsKey(idied)) {
      throw new Exception(
          "Context already has variable of type:$T and id:$id!");
    }
    _variables[idied] = value;
  }
}
