library example.body.json;

import 'dart:async';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

class Info {
  String name;

  List<String> motto;

  Info(this.name, this.motto);

  Map<String, dynamic> toJson() => {
        'name': name,
        'motto': motto,
      };
}

@Controller(path: '/info')
class MathController {
  @GetJson(path: '/jaguar')
  Info jaguar(Context ctx) =>
      new Info('Jaguar', ['Speed', 'Simplicity', 'Extensiblity']);

  @Get(path: '/grizzly')
  Response grizzly(Context ctx) => Response.json(
      new Info('Grizzly', ['Visualization', 'No for loops', 'Data learning']));
}

Future<Null> main(List<String> args) async {
  final jaguar = new Jaguar(port: 10000);
  jaguar.add(reflect(new MathController()));
  await jaguar.serve();
}
