import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lightweight connectivity checker — works on all platforms including web.
///
/// Makes a HEAD request to the backend health endpoint.
/// Falls back to GET /api/v1/lessons if HEAD is not supported.
class ConnectivityService {
  ConnectivityService._();

  static const String _baseUrl = 'http://localhost:4000/api/v1';
  static const Duration _timeout = Duration(seconds: 4);

  static bool _online = false;

  /// Whether the backend was reachable on the last check.
  static bool get isOnline => _online;

  /// Probes the backend with a lightweight GET request.
  /// Updates and returns [isOnline].
  static Future<bool> check() async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        validateStatus: (_) => true, // accept any HTTP status as "reachable"
      ));
      // Hit the auth endpoint with an empty body — returns 400 (bad request)
      // but that still means the server is up.
      await dio.get<void>('$_baseUrl/auth/anonymous');
      _online = true;
    } catch (_) {
      _online = false;
    }
    return _online;
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────────

final connectivityProvider = FutureProvider<bool>((ref) async {
  return ConnectivityService.check();
});
