library jaguar.generator.info;

import 'package:analyzer/dart/element/element.dart';

import 'package:jaguar/src/annotations/import.dart' as ant;
import 'package:source_gen/src/annotation.dart';

import 'package:jaguar/generator/parser/interceptor/import.dart';

export 'package:jaguar/generator/parser/interceptor/import.dart';

part 'group.dart';
part 'route.dart';

class InputInfo {
  final Type resultFrom;

  InputInfo(this.resultFrom);

  InputInfo.FromAnnot(ant.Input inp) : resultFrom = inp.resultFrom;

  String toString() {
    return '$resultFrom';
  }
}