import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

main() async {
  resty.globalClient = new http.IOClient();

  await resty
      .get('http://localhost:10000', '/api/query')
      .query('msg', 'Hello!')
      .go()
      .body
      .then(print);

  await resty
      .get('http://localhost:10000', '/api/path/123')
      .go()
      .body
      .then(print);
}
