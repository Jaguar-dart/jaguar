import 'package:http/http.dart';
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

main() async {
  final url = 'http://localhost:10000/contact';
  resty.globalClient = IOClient();

  await resty.post(url).json({"name": 'Mark', 'age': 32}).go();
  await resty.post(url).json({"name": 'Sam', 'age': 28}).go();

  List<Map> people = await resty.get(url).list();
  print(people);
}
