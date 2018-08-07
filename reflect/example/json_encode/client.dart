import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

class Info {
  String name;

  List<String> motto;

  Info(this.name, this.motto);

  static Info fromJson(Map map) => new Info(map['name'], map['motto']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'motto': motto,
      };

  String toString() => toJson().toString();
}

main() async {
  resty.globalClient = new http.IOClient();

  await resty
      .get('http://localhost:10000/info/jaguar')
      .one(convert: Info.fromJson)
      .then(print);

  await resty
      .get('http://localhost:10000/info/grizzly')
      .one(convert: Info.fromJson)
      .then(print);
}
