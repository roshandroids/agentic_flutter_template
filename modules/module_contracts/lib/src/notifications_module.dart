/// Implemented by whichever push-notification module is enabled.
abstract interface class NotificationsModule {
  Future<bool> requestPermission();

  /// The provider-issued device token, or `null` if not yet available /
  /// permission not granted.
  Future<String?> getToken();

  Stream<Map<String, dynamic>> get onMessageReceived;
}
