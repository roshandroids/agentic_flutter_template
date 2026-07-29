import 'package:module_contracts/module_contracts.dart';
import 'package:test/test.dart';

void main() {
  group('ModuleRegistry', () {
    test('is empty when no descriptors are given', () {
      const registry = ModuleRegistry([]);
      expect(registry.isEmpty, isTrue);
      expect(registry.find('analytics'), isNull);
    });

    test('finds a descriptor by id', () {
      const descriptor = ModuleDescriptor(
        id: 'analytics',
        version: '0.1.0',
        capabilities: {'AnalyticsModule'},
      );
      const registry = ModuleRegistry([descriptor]);

      expect(registry.isEmpty, isFalse);
      expect(registry.find('analytics'), same(descriptor));
      expect(registry.find('missing'), isNull);
    });

    test('reports whether a descriptor declares lifecycle behavior', () {
      const withLifecycle = ModuleDescriptor(
        id: 'firebase',
        version: '0.1.0',
        capabilities: {'AnalyticsModule'},
        hasLifecycle: true,
      );
      const withoutLifecycle = ModuleDescriptor(
        id: 'analytics',
        version: '0.1.0',
        capabilities: {'AnalyticsModule'},
      );

      expect(withLifecycle.hasLifecycle, isTrue);
      expect(withoutLifecycle.hasLifecycle, isFalse);
    });
  });
}
