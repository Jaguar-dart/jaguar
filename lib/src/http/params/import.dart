/// Provides parsing path and query parameters
library jaguar.src.http.params;

import 'dart:mirrors';
import 'package:collection/collection.dart' show DelegatingMap;

import 'package:jaguar/src/utils/string/import.dart';

@proxy
class DottableMap<V> extends DelegatingMap<String, V> {
  DottableMap(Map<String, V> map) : super(map);

  ///Retrieve a value from this map
  V getField(String key, [V defaultValue]) {
    if(!containsKey(key)) {
      return defaultValue;
    }

    return this[key];
  }

  dynamic noSuchMethod(Invocation invocation) {
    var key = MirrorSystem.getName(invocation.memberName);
    if (invocation.isGetter) {
      return getField(key);
    } else if (invocation.isSetter) {
      this[key.substring(0, key.length - 1)] =
          invocation.positionalArguments.first as V;
      return null;
    } else {
      return super.noSuchMethod(invocation);
    }
  }
}

class DynamicDottableMap extends DottableMap<dynamic> {
  DynamicDottableMap(Map<String, dynamic> map) : super(map);

  ///Retrieve a value from this map
  int getFieldAsInt(String key, [int defaultValue]) {
    if(!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if(valueDyn is int) {
      return valueDyn;
    }

    if(valueDyn is String) {
      return stringToInt(valueDyn, defaultValue);
    }

    return defaultValue;
  }

  ///Retrieve a value from this map
  double getFieldAsDouble(String key, [double defaultValue]) {
    if(!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if(valueDyn is double) {
      return valueDyn;
    }

    if(valueDyn is String) {
      return stringToDouble(valueDyn, defaultValue);
    }

    return defaultValue;
  }

  ///Retrieve a value from this map
  num getFieldAsNum(String key, [num defaultValue]) {
    if(!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if(valueDyn is num) {
      return valueDyn;
    }

    if(valueDyn is String) {
      return stringToNum(valueDyn, defaultValue);
    }

    return defaultValue;
  }

  ///Retrieve a value from this map
  bool getFieldAsBool(String key, [bool defaultValue]) {
    if(!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if(valueDyn is bool) {
      return valueDyn;
    }

    if(valueDyn is String) {
      return stringToBool(valueDyn, defaultValue);
    }

    return defaultValue;
  }
}

class PathParams extends DynamicDottableMap {
  PathParams([Map<String, dynamic> map]): super({}) {
    if(map is Map) {
      addAll(map);
    }
  }

  PathParams.FromPathParam(PathParams param): super(param);
}

class QueryParams extends DynamicDottableMap {
  QueryParams(Map<String, dynamic> map): super(map);

  QueryParams.FromQueryParams(QueryParams param): super(param);
}



abstract class Validatable {
  /// Validates the model
  ///
  /// Shall throw an exception in case of validation failure.
  /// The thrown exception must contain the reason for the failure
  void validate();
}