import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/api_client_interface.dart';
import '../services/api/api_client.dart';
import '../config/app_config.dart';

/// Provider for the API client interface
/// This allows for easy testing by providing different implementations
final apiClientProvider = Provider<ApiClientInterface>((ref) {
  final config = ref.watch(appConfigProvider);
  
  return ApiClient(
    baseUrl: config.apiBaseUrl,
    connectTimeout: Duration(seconds: config.apiTimeoutSeconds),
    receiveTimeout: Duration(seconds: config.apiTimeoutSeconds + 5),
  );
});

/// Provider for the singleton API client instance
final apiClientInstanceProvider = Provider<ApiClient>((ref) => ApiClient.instance);

/// Provider that returns the real API client.
/// Mock providers have been removed to comply with zero-simulation hardening.
final environmentAwareApiClientProvider = Provider<ApiClientInterface>((ref) {
  return ref.watch(apiClientProvider);
});

/// Provider for API base URL (useful for dynamic configuration)
final apiBaseUrlProvider = Provider<String>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.apiBaseUrl;
});

/// Provider for API timeout configuration
final apiTimeoutProvider = Provider<Duration>((ref) {
  final config = ref.watch(appConfigProvider);
  return Duration(seconds: config.apiTimeoutSeconds);
});

/// Provider for offline mode state
final offlineModeProvider = StateProvider<bool>((ref) => false);

/// Provider that automatically sets offline mode on the API client
final offlineAwareApiClientProvider = Provider<ApiClientInterface>((ref) {
  final apiClient = ref.watch(environmentAwareApiClientProvider);
  final isOffline = ref.watch(offlineModeProvider);
  
  apiClient.setOfflineMode(isOffline);
  return apiClient;
});