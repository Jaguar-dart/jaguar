library source_gen_experimentation.tool.builder;

import 'package:build/build.dart';

import 'phases.dart';

main() async {
  await build(phases, deleteFilesByDefault: true);
}
