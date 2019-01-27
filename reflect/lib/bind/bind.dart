import 'dart:mirrors';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar/annotations/bind.dart';

RouteHandler bind(Function function) {
  ClosureMirror im = reflect(function);

  final argMaker = <Function>[];

  for (ParameterMirror pm in im.function.parameters) {
    if (pm.isOptional)
      throw UnsupportedError(
          "Optional parameters are not supported by bind yet!");

    pm.metadata.firstWhere((InstanceMirror paim) {
      final reflectee = paim.reflectee;
      if (reflectee is Context) {
        argMaker.add((Context ctx) => ctx);
      } else if (reflectee is Binder) {
        Binder ref = reflectee;
        argMaker.add((Context ctx) => ref.inject(
            MirrorSystem.getName(pm.simpleName), pm.type.reflectedType, ctx));
      } else if (reflectee is Request) {
        argMaker.add((Context ctx) => ctx.req);
      } else {
        argMaker.add(null);
      }
    }, orElse: () => null);
    // TODO
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
