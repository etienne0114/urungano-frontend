import 'package:dio/dio.dart';

/// Interface for API client to enable dependency injection and testing
abstract class ApiClientInterface {
  /// Get the configured Dio instance
  Dio get dio;
  
  /// Base URL for the API
  String get baseUrl;
  
  /// Unwrap the standard API response envelope
  T unwrap<T>(Response<dynamic> response);
  
  /// Update the base URL (useful for environment switching)
  void updateBaseUrl(String newBaseUrl);
  
  /// Update authentication token
  void updateAuthToken(String? token);
  
  /// Clear authentication
  void clearAuth();
  
  /// Check if client is configured for offline mode
  bool get isOfflineMode;
  
  /// Set offline mode
  void setOfflineMode(bool offline);
}