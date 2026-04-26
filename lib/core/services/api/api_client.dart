import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../storage/hive_storage.dart';
import 'api_client_interface.dart';

/// Production implementation of ApiClient with dependency injection support
class ApiClient implements ApiClientInterface {
  late Dio _dio;
  String _baseUrl;
  bool _isOfflineMode = false;

  /// Singleton instance for easy access in services
  static final ApiClient instance = ApiClient();

  ApiClient({
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
  }) : _baseUrl = baseUrl ?? 'http://localhost:4000/api/v1' {
    _initializeDio(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers,
    );
  }

  void _initializeDio({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 10),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Clear existing interceptors
    _dio.interceptors.clear();

    // Auth token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Skip requests in offline mode
          if (_isOfflineMode) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.cancel,
                message: 'Request cancelled: offline mode',
              ),
            );
            return;
          }

          final token = HiveStorage.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (err, handler) {
          // 401 → clear auth; let caller handle navigation
          // Do NOT clear auth if the failure is from the PIN verification endpoint itself
          if (err.response?.statusCode == 401 && 
              !err.requestOptions.path.contains('auth/pin/verify')) {
            HiveStorage.clearAuth();
          }
          handler.next(err);
        },
      ),
    );

    // Development-only logging
    assert(() {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ));
      return true;
    }());
  }

  @override
  Dio get dio => _dio;

  @override
  String get baseUrl => _baseUrl;

  String get wsBaseUrl {
    // Convert 'http://.../api/v1' to 'http://.../chat'
    return _baseUrl.replaceAll('/api/v1', '/chat');
  }

  @override
  bool get isOfflineMode => _isOfflineMode;

  @override
  T unwrap<T>(Response<dynamic> response) => staticUnwrap<T>(response);

  /// Static version of unwrap for use in services without a direct instance
  static T staticUnwrap<T>(Response<dynamic> response) {
    final body = response.data as Map<String, dynamic>;
    return body['data'] as T;
  }

  // Helper methods for instance access proxying to Dio
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get<T>(path, queryParameters: queryParameters);

  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post<T>(path, data: data);

  Future<Response<T>> put<T>(String path, {dynamic data}) =>
      _dio.put<T>(path, data: data);

  Future<Response<T>> patch<T>(String path, {dynamic data}) =>
      _dio.patch<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) =>
      _dio.delete<T>(path);

  @override
  void updateBaseUrl(String newBaseUrl) {
    _baseUrl = newBaseUrl;
    _dio.options.baseUrl = newBaseUrl;
  }

  @override
  void updateAuthToken(String? token) {
    // Token is automatically picked up by the interceptor from HiveStorage
  }

  @override
  void clearAuth() {
    HiveStorage.clearAuth();
  }

  @override
  void setOfflineMode(bool offline) {
    _isOfflineMode = offline;
  }
}
