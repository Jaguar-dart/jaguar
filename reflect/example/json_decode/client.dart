import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

main() async {
  resty.globalClient = new http.IOClient();

  await resty.get('http://localhost:10000', '/api/intercepted').go();

  await resty
      .get('http://localhost:10000', '/api/excepted')
      .go((r) => print(r.body));
}
