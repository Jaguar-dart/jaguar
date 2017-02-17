library jaguar.src.http.context;

import 'package:jaguar/jaguar.dart';

class _IdiedInterceptor {
  final Type interceptor;

  final String id;

  const _IdiedInterceptor(this.interceptor, {this.id});

  //TODO add hashcode and equality
}

abstract class Context {
  Request get req;

  PathParams get pathParams;

  QueryParams get queryParams;

  dynamic getInterceptorOutput(Type interceptor, {String id});
}

class ContextImpl implements Context {
  final Request req;

  final PathParams pathParams;

  QueryParams get queryParams => null;  //TODO

  final List<Interceptor> interceptors = [];

  final _inputs = <_IdiedInterceptor, dynamic>{};

  ContextImpl(this.req, this.pathParams);

  dynamic getInterceptorOutput(Type interceptor, {String id}) {
    // Throw if [interceptor] is not an interceptor
    if (interceptor is! Interceptor) {
      throw new Exception("$interceptor is not a Jaguar interceptor!");
    }
    final idied = new _IdiedInterceptor(interceptor, id: id);
    // Throw if the requested interceptor has not been executed yet
    if (!_inputs.containsKey(_IdiedInterceptor)) {
      throw new Exception(
          "Context does not have output from an interceptor of type:$interceptor and id:$id!");
    }
    return _inputs[idied];
  }

  void addInterceptorOutput(RouteWrapper rw, Interceptor interceptor, dynamic value) {
    if (_inputs.containsKey(_IdiedInterceptor)) {
      throw new Exception(
          "Context already has output from an interceptor of type:${rw.interceptorType} and id:${rw.id}!");
    }
    interceptors.add(interceptor);
    _inputs[new _IdiedInterceptor(rw.interceptorType, id: rw.id)] = value;
  }
}
