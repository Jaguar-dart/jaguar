part of jaguar.http.reflect;

/// A Reflected route. Contains all the information to handle a request for the
/// route
///
/// Call [handleRequest] to handle requests for this route
class ReflectedRoute implements j.RequestHandler {
  /// The route info
  final j.RouteBase route;

  /// Prefix to the route
  final String prefix;

  /// The handler method, function or closure
  final Function handler;

  /// RouteWrappers to wrap the route with interceptors
  final List<j.InterceptorCreator> wrappers;

  final List<j.ExceptionHandler> exceptionHandlers;

  ReflectedRoute(this.route, this.prefix, this.handler, this.wrappers,
      this.exceptionHandlers);

  /// Handles request
  Future<j.Response> handleRequest(j.Context ctx, {String prefix}) async {
    try {
      if (!route.match(ctx.path, ctx.method, prefix, ctx.pathParams)) {
        return null;
      }
      ctx.addInterceptors(wrappers);
      return await j.Interceptor.chain(ctx, handler, route);
    } catch (e, s) {
      for (j.ExceptionHandler handler in exceptionHandlers) {
        InstanceMirror im = reflect(e);
        if (im.type.isAssignableTo(reflectType(handler.exceptionType()))) {
          return handler.onRouteException(ctx, e, s);
        }
      }
      rethrow;
    }
  }

  /// Builds the route for function based routes
  factory ReflectedRoute.build(
      Function handler,
      j.RouteBase jRoute,
      String prefix,
      List<j.InterceptorCreator> wrappers,
      List<j.ExceptionHandler> exceptionHandlers) {
    final InstanceMirror im = reflect(handler);

    if (im is! ClosureMirror) {
      throw new Exception('Route handler must be a closure or function!');
    }

    return new ReflectedRoute(
        jRoute, prefix, handler, wrappers, exceptionHandlers);
  }

  /// Builds the route for class based routes
  factory ReflectedRoute.buildForClass(
      Function handler,
      j.RouteBase jRoute,
      String prefix,
      List<Symbol> wraps,
      InstanceMirror groupIm,
      List<j.ExceptionHandler> exceptionHandlers) {
    final InstanceMirror im = reflect(handler);

    if (im is! ClosureMirror) {
      throw new Exception('Route handler must be a closure or function!');
    }

    final interceptors = <j.InterceptorCreator>[];

    for (final Symbol wrap in wraps) {
      MethodMirror mm = _checkCreator(groupIm.type, wrap);
      if (mm == null)
        throw new Exception("Interceptor creater " +
            MirrorSystem.getName(wrap) +
            " not found!");
      interceptors
          .add((j.Context ctx) => groupIm.invoke(wrap, [ctx]).reflectee);
    }

    return new ReflectedRoute(
        jRoute, prefix, handler, interceptors, exceptionHandlers);
  }
}

MethodMirror _checkCreator(ClassMirror cm, Symbol method) {
  DeclarationMirror dm = cm.declarations[method];

  if (dm != null) {
    if (dm is MethodMirror) return dm;
    throw new Exception("Interceptor creater must be method!");
  }

  dm = _checkCreator(cm.superclass, method);

  if (dm != null) {
    if (dm is MethodMirror) return dm;
    throw new Exception("Interceptor creater must be method!");
  }

  for (ClassMirror scm in cm.superinterfaces) {
    dm = _checkCreator(scm, method);

    if (dm != null) {
      if (dm is MethodMirror) return dm;
      throw new Exception("Interceptor creater must be method!");
    }
  }

  return null;
}
