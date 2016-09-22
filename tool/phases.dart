library source_gen_experimentation.tool.phases;

import 'package:build/build.dart';

import 'package:source_gen/source_gen.dart';

import 'package:jaguar/generators/api_class.dart';

final PhaseGroup phases = new PhaseGroup.singleAction(
    new GeneratorBuilder(const [const ApiClassAnnotationGenerator()]),
    new InputSet('jaguar', const ['example/api.dart']));
