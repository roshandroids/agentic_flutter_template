import 'package:core/core.dart';
import 'package:module_contracts/module_contracts.dart';
import 'package:test/test.dart';

class _FakeAuthModule implements AuthModule {
  @override
  Stream<ModuleUser?> get authStateChanges => Stream.value(null);

  @override
  Future<Result<ModuleUser, Failure>> signInWithEmail(
    String email,
    String password,
  ) async => Ok(ModuleUser(id: 'u1', email: email));

  @override
  Future<Result<void, Failure>> signOut() async => const Ok(null);
}

class _FakeAnalyticsModule implements AnalyticsModule {
  final events = <String>[];

  @override
  void logEvent(String name, {Map<String, Object?> parameters = const {}}) =>
      events.add(name);

  @override
  void setUserProperty(String name, String? value) {}
}

class _FakeNotificationsModule implements NotificationsModule {
  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<String?> getToken() async => 'device-token';

  @override
  Stream<Map<String, dynamic>> get onMessageReceived =>
      Stream.value(const {'title': 'hello'});
}

class _FakePaymentsModule implements PaymentsModule {
  @override
  Future<Result<PurchaseResult, Failure>> purchase(String productId) async =>
      Ok(PurchaseResult(productId: productId, transactionId: 't1'));

  @override
  Future<Result<List<PurchaseResult>, Failure>> restorePurchases() async =>
      const Ok([PurchaseResult(productId: 'p1', transactionId: 't0')]);
}

void main() {
  group('module_contracts', () {
    test('AuthModule is implementable and callable', () async {
      final module = _FakeAuthModule();
      final result = await module.signInWithEmail('a@b.com', 'secret');
      expect(result.dataOrNull?.email, 'a@b.com');
    });

    test('AnalyticsModule is implementable and callable', () {
      final module = _FakeAnalyticsModule();
      module.logEvent('app_open');
      expect(module.events, contains('app_open'));
    });

    test('NotificationsModule is implementable and callable', () async {
      final module = _FakeNotificationsModule();
      expect(await module.requestPermission(), isTrue);
      expect(await module.getToken(), 'device-token');
      expect(
        await module.onMessageReceived.first,
        containsPair('title', 'hello'),
      );
    });

    test('PaymentsModule is implementable and callable', () async {
      final module = _FakePaymentsModule();
      final purchase = await module.purchase('p1');
      expect(purchase.dataOrNull?.transactionId, 't1');

      final restored = await module.restorePurchases();
      expect(restored.dataOrNull, hasLength(1));
    });
  });
}
