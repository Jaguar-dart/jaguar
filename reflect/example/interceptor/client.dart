import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

main() async {
  resty.globalClient = new http.IOClient();

  var template = resty.route('http://localhost:10000');

  // Get request
  await template.get.path('/api/intercepted').go((r) => print(r.body));

  // Get request
  await template.get.path('/api/excepted').go((r) => print(r.body));
}
