/// Provides parsing path and query parameters
library jaguar.src.http.params;

import 'package:collection/collection.dart' show DelegatingMap;

import 'package:jaguar/utils/string/import.dart';

class CastableStringMap extends DelegatingMap<String, String> {
  CastableStringMap(Map<String, String> map) : super(map);

  ///Retrieve a value from this map
  String get(String key, [String defaultValue]) {
    if (!containsKey(key)) {
      return defaultValue;
    }

    return this[key];
  }

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

  DateTime getDateTime(String key, {DateTime defaultValue}) {
    final micros = getInt(key);
    if (micros == null) return defaultValue;

    return DateTime.fromMicrosecondsSinceEpoch(micros, isUtc: true);
  }

  List<String> getList(String key, [Pattern separator = ","]) {
    if (!containsKey(key)) return [];
    return this[key].split(separator);
  }
}

/// Class to hold path parameters
class PathParams extends CastableStringMap {
  PathParams([Map<String, dynamic> map]) : super({}) {
    if (map is Map) {
      addAll(map);
    }
  }

  PathParams.FromPathParam(PathParams param) : super(param);
}

/// Class to hold query parameters
class QueryParams extends CastableStringMap {
  QueryParams(Map<String, dynamic> map) : super(map);

  QueryParams.FromQueryParam(QueryParams param) : super(param);
}
