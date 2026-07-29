import 'package:core/core.dart';

class PurchaseResult {
  const PurchaseResult({required this.productId, required this.transactionId});

  final String productId;
  final String transactionId;
}

/// Implemented by whichever in-app-purchase module is enabled.
abstract interface class PaymentsModule {
  Future<Result<PurchaseResult, Failure>> purchase(String productId);

  Future<Result<List<PurchaseResult>, Failure>> restorePurchases();
}
