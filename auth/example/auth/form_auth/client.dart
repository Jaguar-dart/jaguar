library example.basic_auth.client;

import 'package:http/http.dart' as http;
import 'package:jaguar_client/jaguar_client.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:jaguar_example_session_models/jaguar_example_session_models.dart';

const String kHostname = 'localhost';
const int kPort = 10000;
final String basePath = 'http://localhost:10000';

final client = new JsonClient(new http.IOClient(), manageCookie: true);

getOne() async {
  await client.get(basePath + '/api/book/0').decode(Book.fromMap).then(print);
}

getAll() async {
  await client.get(basePath + '/api/book').decodeList(Book.fromMap).then(print);
}

login() async {
  final JsonResponse resp = await client.authenticateForm(
      new AuthPayload('teja', 'word'),
      url: basePath + '/api/login');
  print(resp.body);
}

runClient() async {
  await login();
  await getOne();
  await getAll();
}
