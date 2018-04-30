library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

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

@Controller(path: '/math')
class MathController {
  @Post(path: '/addition')
  Future<int> addition(Context ctx) async {
    final InputModel input = await ctx.bodyAsJson(convert: InputModel.fromJson);
    return input.add();
  }

  @Post(path: '/subtraction')
  Future<int> subtraction(Context ctx) async {
    final Map body = await ctx.bodyAsJsonMap();
    final InputModel input = InputModel.fromJson(body);
    return input.sub();
  }
}

Future<Null> main(List<String> args) async {
  final jaguar = new Jaguar(port: 10000);
  jaguar.add(reflect(new MathController()));
  await jaguar.serve();
}
