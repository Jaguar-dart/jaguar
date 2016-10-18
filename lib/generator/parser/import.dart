library jaguar.generator.info;

import 'package:jaguar/src/annotations/import.dart' as ant;

export 'package:jaguar/generator/parser/interceptor/import.dart';
export 'package:jaguar/generator/parser/route/import.dart';
export 'package:jaguar/generator/parser/group/import.dart';

/// Holds information about a single input to an interceptor method or function
class InputInfo {
  /// Results of which interceptor must be injected to this input
  final Type resultFrom;

  InputInfo(this.resultFrom);

  InputInfo.FromAnnot(ant.Input inp) : resultFrom = inp.resultFrom;

  String toString() {
    return '$resultFrom';
  }
}