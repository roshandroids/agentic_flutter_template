/// Public API of `core` - Result/Failure error handling and the
/// storage/network interfaces every other package binds to. See
/// docs/architecture/ARCHITECTURE.md and docs/adr/ for why this package
/// exists and what it must never depend on.
library;

export 'src/failure/failure.dart';
export 'src/network/api_client.dart';
export 'src/result/result.dart';
export 'src/storage/key_value_store.dart';
export 'src/storage/secure_store.dart';
