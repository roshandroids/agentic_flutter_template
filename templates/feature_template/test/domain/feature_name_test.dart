// TODO: replace with real behavior tests for feature_name's domain entity.
// See docs/testing/README.md - domain tests are plain `package:test`, no
// Flutter import, no widget harness.
//
// Relative import keeps this analyzable inside templates/; new_feature.sh
// rewrites it to package:app after copy into apps/app/test/features/.
import 'package:flutter_test/flutter_test.dart';

import '../../domain/entities/feature_name.dart';

void main() {
  test('placeholder - replace with a real assertion', () {
    expect(const FeatureName(), isNotNull);
  });
}
