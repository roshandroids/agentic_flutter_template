import 'package:analytics/analytics.dart';
import 'package:test/test.dart';

void main() {
  group('ConsoleAnalyticsModule', () {
    test('logEvent does not throw for an event with parameters', () {
      final module = ConsoleAnalyticsModule();
      expect(
        () => module.logEvent('app_open', parameters: {'source': 'test'}),
        returnsNormally,
      );
    });

    test('setUserProperty does not throw', () {
      final module = ConsoleAnalyticsModule();
      expect(() => module.setUserProperty('plan', 'pro'), returnsNormally);
    });
  });
}
