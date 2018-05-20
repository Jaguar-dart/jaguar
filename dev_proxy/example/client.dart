library example.jaguar_reverse_proxy.client;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

final HttpClient _client = new HttpClient();
final Map<String, Cookie> _cookies = {};

const String kHostname = 'localhost';

const int kPort = 8085;

Future<Null> printHttpClientResponse(HttpClientResponse resp) async {
  StringBuffer contents = new StringBuffer();
  await for (String data in resp.transform(UTF8.decoder)) {
    contents.write(data);
  }

  print('=========================');
  print("body:");
  print(contents.toString());
  print("statusCode:");
  print(resp.statusCode);
  print("headers:");
  print(resp.headers);
  print("cookies:");
  print(resp.cookies);
  print('=========================');
}

Future<Null> getUser() async {
  HttpClientRequest req = await _client.get(kHostname, kPort, '/api/user');
  req.cookies.addAll(_cookies.values);
  HttpClientResponse resp = await req.close();

  for (Cookie cook in resp.cookies) {
    _cookies[cook.name] = cook;
  }

  await printHttpClientResponse(resp);
}

Future<Null> getVersion() async {
  HttpClientRequest req =
      await _client.get(kHostname, kPort, '/client/version');
  req.cookies.addAll(_cookies.values);
  HttpClientResponse resp = await req.close();

  for (Cookie cook in resp.cookies) {
    _cookies[cook.name] = cook;
  }

  await printHttpClientResponse(resp);
}

Future<Null> getIndexHtml() async {
  HttpClientRequest req =
      await _client.get(kHostname, kPort, '/client/index.html');
  req.cookies.addAll(_cookies.values);
  HttpClientResponse resp = await req.close();

  for (Cookie cook in resp.cookies) {
    _cookies[cook.name] = cook;
  }

  await printHttpClientResponse(resp);
}

main() async {
  await getUser();
  await getVersion();
  await getIndexHtml();
  exit(0);
}
