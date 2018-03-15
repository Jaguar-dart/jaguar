library test.jaguar.settings;

import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';

void main() {
  group('settings', () {
    Map<String, String> localSettings = {
      "interval": "1",
    };

    Settings.parse(<String>['-s', 'test/settings/settings.yaml'],
        settingsMap: localSettings);

    test('from map', () async {
      expect(Settings.getString('interval'), "1");
    });

    test('from not found map', () async {
      expect(Settings.getString('notfound'), null);
    });

    test('from map default', () async {
      expect(
          Settings.getString('notfound', defaultValue: 'novalue'), 'novalue');
    });

    test('from yaml {filter: none}', () async {
      expect(Settings.getString('host'), 'localhost');
    });

    test('from yaml {filter: yaml}', () async {
      expect(
          Settings.getString('host', settingsFilter: SettingsFilter.Map), null);
      expect(
          Settings.getString('host', settingsFilter: SettingsFilter.Env), null);
      expect(Settings.getString('host', settingsFilter: SettingsFilter.Yaml),
          'localhost');
    });

    test('from not found yaml', () async {
      expect(
          Settings.getString('notfound', settingsFilter: SettingsFilter.Yaml),
          null);
    });

    test('from yaml default', () async {
      expect(
          Settings.getString('notfound',
              defaultValue: 'novalue', settingsFilter: SettingsFilter.Yaml),
          'novalue');
    });

    test('from env', () async {
      expect(Settings.getString('secret'), null);
      expect(Settings.getString('secret', settingsFilter: SettingsFilter.Map),
          null);
      expect(Settings.getString('secret', settingsFilter: SettingsFilter.Yaml),
          null);
      expect(Settings.getString('secret', settingsFilter: SettingsFilter.Env),
          '123456');
    });

    test('from not found env', () async {
      expect(Settings.getString('notfound', settingsFilter: SettingsFilter.Env),
          null);
    });

    test('from env default', () async {
      expect(
          Settings.getString('notfound',
              defaultValue: 'novalue', settingsFilter: SettingsFilter.Env),
          'novalue');
    });
  });
}
