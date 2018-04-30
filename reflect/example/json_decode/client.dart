import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

main() async {
  resty.globalClient = new http.IOClient();

  await resty.get('http://localhost:10000', '/api/intercepted').fetchResponse;

  await resty
      .get('http://localhost:10000', '/api/excepted')
      .fetchResponse
      .then((r) => print(r.body));
}
