import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

main() async {
  resty.globalClient = new http.IOClient();

  var template = resty.route('http://localhost:10000', '/');

  // Get request
  await template.get.go((r) => print(r.body));

  // Post request
  await template.post.go((r) => print(r.body));

  // Put request
  await template.put.go((r) => print(r.body));

  // Delete request
  await template.delete.go((r) => print(r.body));

  template.path('/json');

  // Get JSON request
  await template.get.one().then(print);

  // Post JSON request
  await template.post.one().then(print);

  // Put JSON request
  await template.put.one().then(print);

  // Delete JSON request
  await template.delete.one().then(print);
}