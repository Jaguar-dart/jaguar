part of jaguar.src.serve;

/// Settings source filter
///
/// Determines where a corresponding setting must be retrieved from
class SettingsFilter {
  final int index;

  final String name;

  String get fullname => "SettingsFilter.$name";

  const SettingsFilter._(this.index, this.name);

  /// Setting shall be retrieved from YAML config file
  static const SettingsFilter Yaml = const SettingsFilter._(0, 'Yaml');

  /// Setting shall be retrieved from environment variables
  static const SettingsFilter Env = const SettingsFilter._(0, 'Env');

  /// Setting shall be retrieved from settings Map provided from dart code
  static const SettingsFilter Map = const SettingsFilter._(0, 'Map');

  /// Setting shall be retrieved from either Map or YAML config file
  static const SettingsFilter MapOrYaml =
      const SettingsFilter._(0, 'MapOrYaml');
}

/// {Key: Value} Settings repository. Allows to query settings values based on
/// keys
class Settings {
  static Settings _singletonInstance;

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
  static Future<Null> parse(List<String> args,
      {Map<String, String> settingsMap: const {}}) async {
    if (_singletonInstance != null) {
      throw new Exception("Settings must be parsed only once!");
    }

    Map<String, dynamic> yamlSettings = {};
    if (args.isNotEmpty) {
      ArgParser parser = new ArgParser();
      parser.addOption('settings', abbr: 's', defaultsTo: '');
      ArgResults results = parser.parse(args);
      String settings = results['settings'];
      if (settings.isNotEmpty && settings.endsWith(".yaml")) {
        File yaml = new File(settings);
        if (await yaml.exists()) {
          yamlSettings = loadYaml(await yaml.readAsString());
        }
      }
    }
    _singletonInstance = new Settings._(yamlSettings, settingsMap);
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
  static String getString(String key,
      {String defaultValue,
      SettingsFilter settingsFilter: SettingsFilter.MapOrYaml}) {
    if (_singletonInstance == null) {
      throw new Exception("Settings are not parsed yet!");
    }

    if (settingsFilter == SettingsFilter.MapOrYaml) {
      String value = _singletonInstance._settingsFromMap[key] ??
          _singletonInstance._settingsFromYaml[key];
      return value ?? defaultValue;
    } else if (settingsFilter == SettingsFilter.Map) {
      return _singletonInstance._settingsFromMap[key] ?? defaultValue;
    } else if (settingsFilter == SettingsFilter.Yaml) {
      var value = _singletonInstance._settingsFromYaml[key] ?? defaultValue;
      if (value is! String) {
        return null;
      }
      return value;
    } else if (settingsFilter == SettingsFilter.Env) {
      return Platform.environment[key] ?? defaultValue;
    }

    return null;
  }
}
