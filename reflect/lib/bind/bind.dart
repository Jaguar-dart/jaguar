import 'dart:mirrors';
import 'package:meta/meta.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar/bind.dart';

final _ctxType = reflectType(Context);
final _reqType = reflectType(Request);

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

    if (pm.metadata.any((im) => im.reflectee == dontBind)) {
      argMaker.add(null);
      continue;
    }

    Function mk;

    if (pm.metadata.isNotEmpty) {
      InstanceMirror paim = pm.metadata
          .firstWhere((p) => p.reflectee is Binder, orElse: () => null);
      if (paim != null) {
        Binder ref = paim.reflectee;
        mk = (Context ctx) => ref.inject(argName, argType, ctx);
      }
    }

    if (mk == null) {
      if (pm.type.isAssignableTo(_ctxType)) {
        mk = (Context ctx) => ctx;
      } else if (pm.type.isAssignableTo(_reqType)) {
        mk = (Context ctx) => ctx.req;
      } else {
        mk = blindBind(argName, argType);
      }
    }

    argMaker.add(mk);
  }

  return (Context ctx) async {
    final args = List(argMaker.length);
    for (int i = 0; i < argMaker.length; i++) {
      Function f = argMaker[i];
      if (f != null) {
        args[i] = await argMaker[i](ctx);
      }
    }
    final ret = im.apply(args);
    return await ret.reflectee;
  };
}
