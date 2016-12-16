library test.jaguar.settings;

import 'dart:io';
import 'dart:async';
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/testing.dart';

part 'settings.g.dart';

@Api(path: '/api')
class SettingsApi extends Object with _$JaguarSettingsApi {
  @Route(path: '/getMap', methods: const <String>['GET'])
  String getMap() => Settings.getString('TEST');

  @Route(path: '/getNotFoundMap', methods: const <String>['GET'])
  String getNotFoundMap() => Settings.getString('TATA');

  @Route(path: '/getMapDefault', methods: const <String>['GET'])
  String getMapDefault() => Settings.getString('TATA', defaultValue: "TATA");

  @Route(path: '/getYaml', methods: const <String>['GET'])
  String getYaml() =>
      Settings.getString('TEST', settingsFilter: SettingsFilter.Yaml);

  @Route(path: '/getNotFoundYaml', methods: const <String>['GET'])
  String getNotFoundYaml() =>
      Settings.getString('TATA', settingsFilter: SettingsFilter.Yaml);

  @Route(path: '/getYamlDefault', methods: const <String>['GET'])
  String getYamlDefault() =>
      Settings.getString('TATA', settingsFilter: SettingsFilter.Yaml, defaultValue: 'TATA');
}

void main() {
  group('settings', () {
    JaguarMock mock;
    setUp(() async {
      Configuration config =
          new Configuration(args: ["-s", "jaguar-test.yaml"]);
      await config.instanciateSettings();
      config.addSettings({"TEST": "TEST"});
      config.addApi(new SettingsApi());
      mock = new JaguarMock(config);
    });

    tearDown(() {});

    test('from map', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/getMap');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'TEST');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('from not found map', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/getNotFoundMap');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('from map default', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/getMapDefault');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'TATA');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('from yaml', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/getYaml');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'TEST');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('from not found yaml', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/getNotFoundYaml');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, '');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });

    test('from yaml default', () async {
      Uri uri = new Uri.http('localhost:8080', '/api/getYamlDefault');
      MockHttpRequest rq = new MockHttpRequest(uri);
      MockHttpResponse response = await mock.handleRequest(rq);

      expect(response.mockContent, 'TATA');
      expect(response.headers.toMap, {});
      expect(response.statusCode, 200);
    });
  });
}
