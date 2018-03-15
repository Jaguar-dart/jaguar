#!/bin/bash

# Fast fail the script on failures.
set -e

$(dirname -- "$0")/ensure_dartfmt.sh

export secret=123456

# Run the tests.
pub run test/test_all.dart

# Install dart_coveralls; gather and send coverage data.
# Re activate coverall when a solution arrive
# if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
#   pub global activate dart_coveralls
#   pub global run dart_coveralls report \
#     --retry 2 \
#     --exclude-test-files \
#     test/test_all.dart
# fi
