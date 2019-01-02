import 'package:build/build.dart';

import 'generator/generator.dart';

Builder jaguarBuilder(BuilderOptions options) =>
    jaguarPartBuilder(header: options.config['header'] as String);
