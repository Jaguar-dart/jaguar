import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

main() async {
  resty.globalClient = new http.IOClient();

  await resty
      .get('http://localhost:10000/api/get')
      .go()
      .then((r) => print(r.body));
}
