import 'dart:async';
import 'package:meta/meta.dart';

import 'package:jaguar/jaguar.dart';

@experimental
abstract class Binder {
  FutureOr inject(String argName, Type argType, Context ctx);
}

@experimental
const pathParam = PathParam();

@experimental
const queryParam = QueryParam();

@experimental
class PathParam implements Binder {
  final String name;

  const PathParam([this.name]);

  dynamic inject(String argName, Type argType, Context ctx) {
    String alias = name ?? argName;
    if (argType == String) {
      return ctx.pathParams.get(alias);
    }
    if (argType == int) {
      return ctx.pathParams.getInt(alias);
    }
    if (argType == double) {
      return ctx.pathParams.getDouble(alias);
    }
    if (argType == num) {
      return ctx.pathParams.getNum(alias);
    }
    if (argType == bool) {
      return ctx.pathParams.getBool(alias);
    }
    if (argType == List) {
      return ctx.pathParams.getList(alias);
    }
    return null;
  }
}

@experimental
class QueryParam implements Binder {
  final String name;

  const QueryParam([this.name]);

  dynamic inject(String argName, Type argType, Context ctx) {
    String alias = name ?? argName;
    if (argType == String) {
      return ctx.query.get(alias);
    }
    if (argType == int) {
      return ctx.query.getInt(alias);
    }
    if (argType == double) {
      return ctx.query.getDouble(alias);
    }
    if (argType == num) {
      return ctx.query.getNum(alias);
    }
    if (argType == bool) {
      return ctx.query.getBool(alias);
    }
    if (argType == List) {
      return ctx.query.getList(alias);
    }
    return null;
  }
}

/* TODO
@experimental
class Body implements Binder {
  const Body();
}
*/
