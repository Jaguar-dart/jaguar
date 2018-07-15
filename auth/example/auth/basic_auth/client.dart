library example.basic_auth.client;

import 'package:http/http.dart' as http;
import 'package:jaguar_client/jaguar_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar_example_session_models/jaguar_example_session_models.dart';

final String basePath = 'http://localhost:10000';

final client = new JsonClient(new http.IOClient(), manageCookie: true);

main() async {
  // Without login
  await client.get(basePath + '/books').expect([statusCodeIs(401)]);

  // Login with wrong username:password
  await client
      .authenticateBasic(AuthPayload('teja', 'wrong password'),
          url: basePath + '/login')
      .expect([statusCodeIs(401)]);

  await client.authenticateBasic(AuthPayload('teja', 'word'),
      url: basePath + '/login');

  await client.get(basePath + '/books').decodeList(Book.fromMap).then(print);
}
