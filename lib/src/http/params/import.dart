/// Provides parsing path and query parameters
library jaguar.src.http.params;

import 'package:collection/collection.dart' show DelegatingMap;

import 'package:jaguar/src/utils/string/import.dart';

/// A [Map] whose keys can be accessed as if they are members of the object
@proxy
class DottableMap<V> extends DelegatingMap<String, V> {
  DottableMap(Map<String, V> map) : super(map);

  ///Retrieve a value from this map
  V get(String key, [V defaultValue]) {
    if (!containsKey(key)) {
      return defaultValue;
    }

    return this[key];
  }

  /* Reimplement it without Mirrors
  dynamic noSuchMethod(Invocation invocation) {
    var key = invocation.memberName;
    if (invocation.isGetter) {
      return get(key);
    } else if (invocation.isSetter) {
      this[key.substring(0, key.length - 1)] =
          invocation.positionalArguments.first as V;
      return null;
    } else {
      return super.noSuchMethod(invocation);
    }
  }
  */
}

class DynamicDottableMap extends DottableMap<dynamic> {
  DynamicDottableMap(Map<String, dynamic> map) : super(map);

  ///Retrieve a value from this map
  int getInt(String key, [int defaultValue]) {
    if (!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if (valueDyn is int) {
      return valueDyn;
    }

    if (valueDyn is String) {
      return stringToInt(valueDyn, defaultValue);
    }

    return defaultValue;
  }

  ///Retrieve a value from this map
  double getDouble(String key, [double defaultValue]) {
    if (!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if (valueDyn is double) {
      return valueDyn;
    }

    if (valueDyn is String) {
      return stringToDouble(valueDyn, defaultValue);
    }

    return defaultValue;
  }

  ///Retrieve a value from this map
  num getNum(String key, [num defaultValue]) {
    if (!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if (valueDyn is num) {
      return valueDyn;
    }

    if (valueDyn is String) {
      return stringToNum(valueDyn, defaultValue);
    }

    return defaultValue;
  }

  ///Retrieve a value from this map
  bool getBool(String key, [bool defaultValue]) {
    if (!containsKey(key)) {
      return defaultValue;
    }

    dynamic valueDyn = this[key];

    if (valueDyn is bool) {
      return valueDyn;
    }

    if (valueDyn is String) {
      return stringToBool(valueDyn, defaultValue);
    }

    return defaultValue;
  }
}

/// Class to hold path parameters
class PathParams extends DynamicDottableMap {
  PathParams([Map<String, dynamic> map]) : super({}) {
    if (map is Map) {
      addAll(map);
    }
  }

  PathParams.FromPathParam(PathParams param) : super(param);
}

/// Class to hold query parameters
/// @proxy
class QueryParams extends DynamicDottableMap {
  QueryParams(Map<String, dynamic> map) : super(map);

  QueryParams.FromQueryParam(QueryParams param) : super(param);
}

/// Interface that must be implemented by all validatable objects
abstract class Validatable {
  /// Validates the object
  ///
  /// Shall throw an exception in case of validation failure.
  /// The thrown exception must contain the reason for the failure
  void validate();
}
