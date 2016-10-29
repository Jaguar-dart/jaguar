/// Provides parsing path and query parameters
library jaguar.src.http.params;

import 'dart:mirrors';
import 'package:collection/collection.dart' show DelegatingMap;

class DynamicMap<V> extends DelegatingMap<String, V> {
  DynamicMap(Map<String, V> map) : super(map);

  ///Retrieve a value from this map
  V getField(String key, [V defaultValue]) {
    if (containsKey(key)) {
      return this[key];
    } else if (defaultValue != null) {
      return defaultValue;
    }

    return null;
  }

  dynamic noSuchMethod(Invocation invocation) {
    var key = MirrorSystem.getName(invocation.memberName);
    if (invocation.isGetter) {
      return getField(key);
    } else if (invocation.isSetter) {
      this[key.substring(0, key.length - 1)] =
          invocation.positionalArguments.first;
      return null;
    } else {
      return super.noSuchMethod(invocation);
    }
  }
}

class PathParams extends DynamicMap<dynamic> {
  PathParams(Map<String, dynamic> map): super(map);
}

class QueryParams extends DynamicMap<dynamic> {
  QueryParams(Map<String, dynamic> map): super(map);
}