import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';

import 'package:jaguar/jaguar.dart';

@experimental
abstract class Binder {
  FutureOr inject(String argName, Type argType, Context ctx);
}

@experimental
const bindPath = PathParam();

@experimental
const bindQuery = QueryParam();

@experimental
const bindVar = Var();

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
    if (argType == DateTime) {
      return ctx.pathParams.getDateTime(alias);
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
    if (argType == DateTime) {
      return ctx.query.getDateTime(alias);
    }
    if (argType == List) {
      return ctx.query.getList(alias);
    }
    return null;
  }
}

@experimental
class Var implements Binder {
  final String id;

  const Var({this.id});

  dynamic inject(String argName, Type argType, Context ctx) {
    return ctx.getVariable(id: id, type: argType);
  }
}

@experimental
class JsonBody implements Binder {
  final Encoding enc;
  const JsonBody({this.enc});

  Future<dynamic> inject(String argName, Type argType, Context ctx) async {
    final ret = await ctx.bodyAsJson(encoding: enc);
    if (argType == Object || argType == dynamic) return ret;
    if (ret == null) return ret;
    if (ret.runtimeType != argType) return null;
    return ret;
  }
}

@experimental
class Json<T> implements Binder {
  final Encoding enc;

  const Json({this.enc});

  Future<dynamic> inject(String argName, Type argType, Context ctx) {
    if (argType == List) return ctx.bodyAsJsonList(encoding: enc);

    return ctx.bodyAsJson(encoding: enc);
  }
}

bool _isBuiltIn(Type argType) {
  switch (argType) {
    case String:
      return true;
    case int:
      return true;
    case num:
      return true;
    case double:
      return true;
    case bool:
      return true;
    case DateTime:
      return true;
    default:
      return false;
  }
}

RouteHandler blindBind(String argName, Type argType) {
  return (Context ctx) async {
    if (_isBuiltIn(argType)) {
      // Try "path parameter"
      if (ctx.pathParams.containsKey(argName)) {
        return PathParam(argName).inject(argName, argType, ctx);
      }
      // Try "query"
      if (ctx.query.containsKey(argName)) {
        return QueryParam(argName).inject(argName, argType, ctx);
      }
    }
    // Try variable
    {
      final ret = ctx.getVariable(type: argType);
      if (ret != null) return ret;
    }
    // Try JSON deserializer
    if (ctx.isJson) {
      if (argType == Map) return ctx.bodyAsJsonMap();
      if (argType != List) {
        // Try JSON PODO deserialization
        final ser = ctx.serializerFor(argType);
        if (ser != null) return ser.fromMap(await ctx.bodyAsJsonMap());
      }
    }
    return null;
  };
}

class _DontBind {
  const _DontBind();
}

const dontBind = _DontBind();
