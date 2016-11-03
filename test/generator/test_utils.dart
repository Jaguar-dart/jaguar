library jaguar.test.utils;

import 'dart:mirrors';

import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

String _packagePathCache;

String getPackagePath() {
  // TODO(kleak) - ideally we'd have a more clean way to do this
  // See https://github.com/dart-lang/sdk/issues/23990
  if (_packagePathCache == null) {
    var currentFilePath =
        currentMirrorSystem().findLibrary(#jaguar.test.utils).uri.path;

    _packagePathCache = p.normalize(p.join(p.dirname(currentFilePath), '..'));
  }
  return _packagePathCache;
}

const Matcher throwsInvalidGenerationSourceError =
    const Throws(isInvalidGenerationSourceError);

const Matcher isInvalidGenerationSourceError =
    const _InvalidGenerationSourceError();

class _InvalidGenerationSourceError extends TypeMatcher {
  const _InvalidGenerationSourceError() : super("InvalidGenerationSourceError");

  @override
  bool matches(item, Map matchState) => item is InvalidGenerationSourceError;
}
