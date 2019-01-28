import 'dart:mirrors';
import 'package:meta/meta.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar/annotations/bind.dart';

final _ctxType = reflectType(Context);
final _reqType = reflectType(Request);

RouteHandler _onlineInjection(String argName, Type argType) {
  return (Context ctx) {
    if (ctx.pathParams.containsKey(argName)) {
      return PathParam(argName).inject(argName, argType, ctx);
    } else if (ctx.query.containsKey(argName)) {
      return QueryParam(argName).inject(argName, argType, ctx);
    }
    return null;
  };
}

@experimental

/// Dependency injection for route handlers
RouteHandler bind(Function function) {
  ClosureMirror im = reflect(function);

  final argMaker = <Function>[];

  for (ParameterMirror pm in im.function.parameters) {
    if (pm.isOptional)
      throw UnsupportedError(
          "Optional parameters are not supported by bind yet!");

    String argName = MirrorSystem.getName(pm.simpleName);
    Type argType = pm.type.reflectedType;

    if (pm.metadata.isNotEmpty) {
      InstanceMirror paim = pm.metadata
          .firstWhere((p) => p.reflectee is Binder, orElse: () => null);
      if (paim != null) {
        Binder ref = paim.reflectee;
        argMaker.add((Context ctx) => ref.inject(argName, argType, ctx));
      } else {
        if (pm.type.isAssignableTo(_ctxType)) {
          argMaker.add((Context ctx) => ctx);
        } else if (pm.type.isAssignableTo(_reqType)) {
          argMaker.add((Context ctx) => ctx.req);
        } else {
          argMaker.add(_onlineInjection(argName, argType));
        }
      }
    } else {
      argMaker.add(_onlineInjection(argName, argType));
    }
  }

  return (Context ctx) async {
    final args = List(argMaker.length);
    for (int i = 0; i < argMaker.length; i++) {
      Function f = argMaker[i];
      if (f != null) {
        args[i] = await argMaker[i](ctx);
      }
    }
    final ret = await im.apply(args);
    return ret.reflectee;
  };
}
