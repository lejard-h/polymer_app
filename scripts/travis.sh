#!/usr/bin/env bash

echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS \
  bin/polymer_app.dart \
  lib/http_service.dart \
  lib/polymer_app_manager.dart \
  lib/polymer_app_behaviors.dart \
  lib/polymer_app_models.dart \
  lib/polymer_app_services.dart \
  lib/polymer_app_elements.dart \
  lib/polymer_app_routes.dart \
  lib/polymer_router.dart \
  lib/polymer_model.dart \
  lib/serializer.dart \
  lib/utils.dart

# Run the tests.
echo "Running tests..."
pub run test ./test/serializer.dart

if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  echo "Running coverage..."
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --retry 2 \
    --debug \
    test/serializer.dart \
    bin/polymer_app.dart
fi