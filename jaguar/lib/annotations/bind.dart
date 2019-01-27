import 'dart:async';
import 'package:jaguar/jaguar.dart';

abstract class Binder {
  FutureOr inject(String argName, Type argType, Context ctx);
}

final pathParam = PathParam();

final queryParam = QueryParam();

class PathParam implements Binder {
  final String name;

  PathParam([this.name]);

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

class QueryParam implements Binder {
  final String name;

  QueryParam([this.name]);

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
class Body implements Binder {
  const Body();
}
*/
