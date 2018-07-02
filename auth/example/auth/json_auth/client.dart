library example.basic_auth.client;

import 'package:http/http.dart' as http;
import 'package:jaguar_client/jaguar_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import '../../model/model.dart';

const String kHostname = 'localhost';
const int kPort = 10000;
final String basePath = 'http://localhost:10000';

final client = new JsonClient(new http.IOClient(), manageCookie: true);

getOne() async {
  await client.get(basePath + '/api/book/0').decode(Book.fromJson).then(print);
}

getAll() async {
  await client
      .get(basePath + '/api/book')
      .decodeList(Book.fromJson)
      .then(print);
}

login() async {
  final JsonResponse resp = await client.authenticate(
      new AuthPayload('teja', 'word'),
      url: basePath + '/api/login');
  print(resp.body);
}

runClient() async {
  // Without login
  await client.get(basePath + '/api/book/0').expect([statusCodeIs(401)]);

  // Login with wrong username:password
  await client
      .authenticate(new AuthPayload('teja', 'wrong password'),
          url: basePath + '/api/login')
      .expect([statusCodeIs(401)]);

  await login();
  await getOne();
  await getAll();
}
