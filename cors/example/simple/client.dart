library jaguar_mux.example.simple.client;

import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

const String baseUrl = 'http://localhost:10000';

Future<void> onlySameOrigin() async {
  await resty.get(baseUrl + '/none').expect([resty.bodyIs('none')]);
  await resty
      .get(baseUrl + '/none')
      .header('Origin', 'http://example.com:8000')
      .expect([
    resty.bodyIs('Invalid CORS request: Origin not allowed!'),
    resty.statusCodeIs(403)
  ]);
}

Future<void> originMatch() async {
  await resty.get(baseUrl + '/origins').go().expect([resty.bodyIs('origins')]);
  await resty
      .get(baseUrl + '/origins')
      .header('Origin', 'http://example1.com')
      .expect([resty.bodyIs('origins'), resty.statusCodeIs(200)]);
  await resty
      .get(baseUrl + '/origins')
      .header('Origin', 'http://example2.com')
      .expect([
    resty.bodyIs('Invalid CORS request: Origin not allowed!'),
    resty.statusCodeIs(403)
  ]);
}

Future<void> preflight() async {
  await resty.options(baseUrl + '/origins').headers({
    'Origin': 'http://example.com',
    'Access-Control-Request-Method': 'GET',
  }).expect([
    resty.bodyIs('preflight'),
    resty.headersHas('access-control-allow-origin',
        r'http://example.com, http://example1.com'),
    resty.headersHas('access-control-allow-methods', '*'),
    resty.headersHas('access-control-allow-headers', '*'),
  ]);
}

main() async {
  resty.globalClient = new http.IOClient();

  await onlySameOrigin();
  await originMatch();
  await preflight();

  exit(0);
}
