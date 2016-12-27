part of jaguar.src.serve;

enum SettingsFilter { Yaml, Env, Map, MapOrYaml }

class Settings {
  static Settings _singletonInstance;

  final Map<String, dynamic> _settingsFromYaml;
  final Map<String, String> _settingsFromMap;

  Settings._(Map<String, dynamic> settingsFromYaml,
      Map<String, String> settingsFromMap)
      : _settingsFromYaml = settingsFromYaml ?? {},
        _settingsFromMap = settingsFromMap ?? {};

  static Future<Null> parse(
      List<String> args, Map<String, String> settingsMap) async {
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

  static String getString(String key,
      {String defaultValue,
      SettingsFilter settingsFilter: SettingsFilter.MapOrYaml}) {
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
  }
}
