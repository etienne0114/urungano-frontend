import 'package:dio/dio.dart';
import '../connectivity_service.dart';
import '../storage/hive_storage.dart';
import 'api_client.dart';

/// Authentication service.
///
/// Token and userId are ALWAYS stored in Hive (device-local).
/// Backend calls are only made when online.
class AuthService {
  AuthService._();

  // ── Sign in ───────────────────────────────────────────────

  /// Signs in anonymously.
  ///
  /// ONLINE:  calls backend → stores token + userId in Hive → returns result
  /// OFFLINE: returns null → caller uses existing Hive session
  static Future<({String userId, String username, bool isNewUser})?> signInAnonymous(
    String username,
  ) async {
    final online = await ConnectivityService.check();
    if (!online) return null;

    try {
      final res = await ApiClient.instance.post<Map<String, dynamic>>(
        '/auth/anonymous',
        data: {'username': username},
      );
      final data = ApiClient.staticUnwrap<Map<String, dynamic>>(res);
      final saved = await HiveStorage.saveAuth(
        data['accessToken'] as String,
        data['userId']      as String,
      );
      
      if (!saved) return null;
      
      return (
        userId:    data['userId']   as String,
        username:  data['username'] as String,
        isNewUser: data['isNewUser'] as bool,
      );
    } catch (e) {
      return null;
    }
  }

  // ── PIN ───────────────────────────────────────────────────

  /// Sets PIN on the backend.
  /// ONLINE: syncs to backend.
  /// OFFLINE: returns false — PIN is already saved locally in Hive.
  static Future<bool> setPin(String pin) async {
    final online = await ConnectivityService.check();
    if (!online) return false;

    try {
      await ApiClient.instance.post<void>('/auth/pin/set', data: {'pin': pin});
      return true;
    } on DioException {
      return false;
    }
  }

  /// Verifies PIN against the backend and refreshes the token.
  /// ONLINE:  verifies with backend → stores new token in Hive.
  /// OFFLINE: returns null → caller uses local SHA-256 hash check (Hive).
  static Future<String?> verifyPin(String userId, String pin) async {
    final online = await ConnectivityService.check();
    if (!online) return null;

    try {
      final res = await ApiClient.instance.post<Map<String, dynamic>>(
        '/auth/pin/verify/$userId',
        data: {'pin': pin},
      );
      final data  = ApiClient.staticUnwrap<Map<String, dynamic>>(res);
      final token = data['accessToken'] as String;
      await HiveStorage.saveAuth(token, userId);
      return token;
    } on DioException {
      return null;
    }
  }

  /// Removes PIN from the backend.
  /// ONLINE: syncs removal to backend.
  /// OFFLINE: returns false — local Hive PIN hash is cleared by the caller.
  static Future<bool> removePin() async {
    final online = await ConnectivityService.check();
    if (!online) return false;

    try {
      await ApiClient.instance.post<void>('/auth/pin/remove');
      return true;
    } on DioException {
      return false;
    }
  }
}
