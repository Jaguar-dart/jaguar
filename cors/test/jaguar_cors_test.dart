// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

//TODO import 'package:jaguar_cors/jaguar_cors.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_cors/jaguar_cors.dart';
import 'package:test/test.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:10000';

void main() {
  resty.globalClient = new http.IOClient();

  group('A group of tests', () {
    Jaguar server = new Jaguar(port: 10000);

    setUp(() async {
      server.get('/none', (_) => 'none', before: [new Cors(new CorsOptions())]);

      {
        final options = new CorsOptions(
            allowedOrigins: ['http://example.com', 'http://example1.com'],
            allowAllMethods: true,
            allowAllHeaders: true);
        server.get('/origins', (_) => 'origins', before: [new Cors(options)]);
      }

      {
        final options = new CorsOptions(
            allowedOrigins: ['http://example.com', 'http://example1.com'],
            allowAllMethods: true,
            allowAllHeaders: true);
        server.route('/origins', (_) => 'preflight',
            methods: ['OPTIONS'], before: [new Cors(options)]);
      }

      await server.serve();
    });

    tearDown(() {
      server.close();
    });

    test('Default', () async {
      await resty.get(baseUrl, '/none').expect([resty.bodyIs('none')]);
      await resty
          .get(baseUrl, '/none')
          .header('Origin', 'http://example.com:8000')
          .expect([
        resty.bodyIs('Invalid CORS request: Origin not allowed!'),
        resty.statusCodeIs(403)
      ]);
    });

    test('OriginsMatch', () async {
      await resty.get(baseUrl, '/origins').go().expect([resty.bodyIs('origins')]);
      await resty
          .get(baseUrl, '/origins')
          .header('Origin', 'http://example1.com')
          .expect([resty.bodyIs('origins'), resty.statusCodeIs(200)]);
      await resty
          .get(baseUrl, '/origins')
          .header('Origin', 'http://example2.com')
          .expect([
        resty.bodyIs('Invalid CORS request: Origin not allowed!'),
        resty.statusCodeIs(403)
      ]);
    });

    test('Preflight', () async {
      await resty.options(baseUrl, '/origins').headers({
        'Origin': 'http://example.com',
        'Access-Control-Request-Method': 'GET',
      }).expect([
        resty.bodyIs('preflight'),
        resty.headersHas('access-control-allow-origin',
            r'http://example.com, http://example1.com'),
        resty.headersHas('access-control-allow-methods', '*'),
        resty.headersHas('access-control-allow-headers', '*'),
      ]);
    });
  });
}
