library settings;

import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

/// {Key: Value} Settings repository. Allows to query settings values based on
/// keys
class Settings {
  static Settings _singleton;

  final Map<String, dynamic> _settingsFromYaml;

  final Map<String, String> _settingsFromMap;

  Settings._(Map<String, dynamic> settingsFromYaml,
      Map<String, String> settingsFromMap)
      : _settingsFromYaml = settingsFromYaml ?? {},
        _settingsFromMap = settingsFromMap ?? {};

  /// Parses settings provided from various sources
  ///
  /// Must be called before querying setting values
  /// Must be called only once
  ///
  /// @param args Command line arguments. Used to parse the location of YAML
  ///   config file passed through '-s' command line flag
  /// @param settingsMap Settings provided through Dart Map
  static Future<void> parse(List<String> args,
      {Map<String, String> settingsMap: const {}}) async {
    if (_singleton != null) return;

    Map<String, dynamic> yamlSettings = {};
    if (args.isNotEmpty) {
      final parser = ArgParser();
      parser.addOption('settings', abbr: 's', defaultsTo: '');
      ArgResults results = parser.parse(args);
      String settings = results['settings'];
      if (settings.isNotEmpty && settings.endsWith(".yaml")) {
        final yaml = File(settings);
        if (await yaml.exists()) {
          yamlSettings = (loadYaml(await yaml.readAsString()) as Map)
              .cast<String, dynamic>();
        }
      }
    }
    _singleton = Settings._(yamlSettings, settingsMap);
  }

  static dynamic get(String key, {defaultValue}) {
    if (_singleton == null) throw Exception("Settings are not parsed yet!");

    dynamic ret;

    if (Platform.environment.containsKey(key)) {
      ret = Platform.environment[key];
    } else if (_singleton._settingsFromYaml.containsKey(key)) {
      ret = _singleton._settingsFromYaml[key];
    } else if (_singleton._settingsFromMap.containsKey(key)) {
      ret = _singleton._settingsFromMap[key];
    } else {
      ret = defaultValue;
    }

    return ret;
  }

  /// Returns a setting value based on the provided key
  ///
  /// Must be called only after the settings are parsed
  ///
  /// @param key Key of the setting
  /// @param defaultValue Defualt value that must be returned if setting for
  ///   given key is not found
  /// @param settingsFilter Filters the source from which the setting values are
  ///   retrieved
  static String getString(String key, {String defaultValue}) {
    if (_singleton == null) throw Exception("Settings are not parsed yet!");

    dynamic ret = get(key);

    if (ret == null) return defaultValue;
    if (ret is! String) throw Exception('Value is not string');
    return ret;
  }

  static int getInt(String key, {int defaultValue, int radix}) {
    dynamic v = get(key);
    if (v == null) return defaultValue;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v, radix: radix) ?? defaultValue;
    throw Exception('Value is not int');
  }

  static double getDouble(String key, {double defaultValue}) {
    dynamic v = get(key);
    if (v == null) return defaultValue;
    if (v is double) return v;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? defaultValue;
    throw Exception('Value is not double');
  }

  static bool getBool(String key, {bool defaultValue}) {
    dynamic v = get(key);
    if (v == null) return defaultValue;
    if (v is bool) return v;
    if (v is String) {
      v = (v as String).toLowerCase();
      if (v == 'true' || v == 'yes' || v == 'y' || v == 'ok' || v == 'yep')
        return true;
      if (v == 'false' || v == 'no' || v == 'n' || v == 'nope') return false;
    }
    throw Exception('Value is not bool');
  }
}
