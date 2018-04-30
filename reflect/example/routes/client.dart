import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;

class InputModel {
  InputModel(this.input1, this.input2);

  final int input1;

  final int input2;

  int add() => input1 + input2;

  int sub() => input1 - input2;

  static InputModel fromJson(Map<String, dynamic> map) =>
      new InputModel(map['input1'], map['input2']);

  Map toJson() => {
        'input1': input1,
        'input2': input2,
      };
}

main() async {
  resty.globalClient = new http.IOClient();

  await resty
      .post('/math/addition')
      .authority('http://localhost:10000')
      .json(new InputModel(20, 5))
      .fetchResponse
      .then((r) => print(r.body));

  await resty
      .post('/math/subtraction')
      .authority('http://localhost:10000')
      .json(new InputModel(60, 5))
      .fetchResponse
      .then((r) => print(r.body));
}
