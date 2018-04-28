import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator/generator.dart';

Builder jaguar(BuilderOptions options) => new PartBuilder([new ApiGenerator()]);
