library example.basic_auth.client;

import 'package:http/http.dart' as http;
import 'package:jaguar_client/jaguar_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:mongo_dart/mongo_dart.dart';

final String basePath = 'http://localhost:10000/api';

final client = JsonClient(http.IOClient(), manageCookie: true);

main() async {
  final db = new Db('mongodb://localhost:27018/test');
  await db.open();
  await db.collection('user').remove(<String, dynamic>{});
  await db.collection('user').insert({'username': 'teja', 'password': 'word'});

  // Without login
  await client.get(basePath + '/books').expect([statusCodeIs(401)]);

  // Login with wrong username:password
  await client
      .authenticateBasic(AuthPayload('teja', 'wrong password'),
          url: basePath + '/auth/login')
      .expect([statusCodeIs(401)]);

  await client.authenticateBasic(AuthPayload('teja', 'word'),
      url: basePath + '/auth/login');

  await client.get(basePath + '/books').then((r) => print(r.body));
}
