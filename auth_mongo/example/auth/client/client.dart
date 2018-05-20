library example.basic_auth.client;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:auth_header/auth_header.dart';
import 'package:mongo_dart/mongo_dart.dart';

final HttpClient _client = new HttpClient();
final Map<String, Cookie> _cookies = {};

const String kHostname = 'localhost';

const int kPort = 10000;

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

getAll() async {
  HttpClientRequest req = await _client.get(kHostname, kPort, '/api/book/all');
  req.cookies.addAll(_cookies.values);
  HttpClientResponse resp = await req.close();

  for (Cookie cook in resp.cookies) {
    _cookies[cook.name] = cook;
  }

  await printHttpClientResponse(resp);
}

login() async {
  HttpClientRequest req =
      await _client.post(kHostname, kPort, '/api/auth/login');
  req.cookies.addAll(_cookies.values);

  AuthHeaders auth = new AuthHeaders();
  String credentials =
      const Base64Codec.urlSafe().encode('teja:word'.codeUnits);
  auth.addItem(new AuthHeaderItem('Basic', credentials));

  req.headers.add(HttpHeaders.AUTHORIZATION, auth.toString());
  HttpClientResponse resp = await req.close();

  for (Cookie cook in resp.cookies) {
    _cookies[cook.name] = cook;
  }

  await printHttpClientResponse(resp);
}

client() async {
  final db = new Db('mongodb://localhost:27017/test');
  await db.open();
  await db.collection('user').remove({});
  await db.collection('user').insert({'username': 'teja', 'password': 'word'});

  await login();
  await getAll();
}
