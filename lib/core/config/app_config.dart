import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application configuration class
class AppConfig {
  final String apiBaseUrl;
  final int apiTimeoutSeconds;
  final bool enableLogging;
  final bool isTestEnvironment;
  final bool isDebugMode;
  final String appVersion;
  final String buildNumber;
  final Map<String, dynamic> featureFlags;

  const AppConfig({
    required this.apiBaseUrl,
    this.apiTimeoutSeconds = 10,
    this.enableLogging = true,
    this.isTestEnvironment = false,
    this.isDebugMode = kDebugMode,
    this.appVersion = '1.0.0',
    this.buildNumber = '1',
    this.featureFlags = const {},
  });

  /// Development configuration
  static const AppConfig development = AppConfig(
    apiBaseUrl: 'http://localhost:4000/api/v1',
    apiTimeoutSeconds: 10,
    enableLogging: true,
    isTestEnvironment: false,
    featureFlags: {
      'enableWebSocket': true,
      'enablePushNotifications': true,
      'enableOfflineMode': true,
      'enableCommunityFeatures': true,
    },
  );

  /// Production configuration
  static const AppConfig production = AppConfig(
    apiBaseUrl: 'https://api.urungano.app/api/v1',
    apiTimeoutSeconds: 15,
    enableLogging: false,
    isTestEnvironment: false,
    featureFlags: {
      'enableWebSocket': true,
      'enablePushNotifications': true,
      'enableOfflineMode': true,
      'enableCommunityFeatures': true,
    },
  );

  /// Testing configuration
  static const AppConfig testing = AppConfig(
    apiBaseUrl: 'http://mock-api.test/api/v1',
    apiTimeoutSeconds: 5,
    enableLogging: false,
    isTestEnvironment: true,
    featureFlags: {
      'enableWebSocket': false,
      'enablePushNotifications': false,
      'enableOfflineMode': true,
      'enableCommunityFeatures': false,
    },
  );

  /// Staging configuration
  static const AppConfig staging = AppConfig(
    apiBaseUrl: 'https://staging-api.urungano.app/api/v1',
    apiTimeoutSeconds: 12,
    enableLogging: true,
    isTestEnvironment: false,
    featureFlags: {
      'enableWebSocket': true,
      'enablePushNotifications': false,
      'enableOfflineMode': true,
      'enableCommunityFeatures': true,
    },
  );

  /// Get configuration based on environment
  static AppConfig get current {
    const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    
    switch (environment.toLowerCase()) {
      case 'production':
        return production;
      case 'staging':
        return staging;
      case 'testing':
      case 'test':
        return testing;
      case 'development':
      case 'dev':
      default:
        return development;
    }
  }

  /// Check if a feature flag is enabled
  bool isFeatureEnabled(String featureName) {
    return featureFlags[featureName] == true;
  }

  /// Create a copy with updated values
  AppConfig copyWith({
    String? apiBaseUrl,
    int? apiTimeoutSeconds,
    bool? enableLogging,
    bool? isTestEnvironment,
    bool? isDebugMode,
    String? appVersion,
    String? buildNumber,
    Map<String, dynamic>? featureFlags,
  }) {
    return AppConfig(
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      apiTimeoutSeconds: apiTimeoutSeconds ?? this.apiTimeoutSeconds,
      enableLogging: enableLogging ?? this.enableLogging,
      isTestEnvironment: isTestEnvironment ?? this.isTestEnvironment,
      isDebugMode: isDebugMode ?? this.isDebugMode,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      featureFlags: featureFlags ?? this.featureFlags,
    );
  }

  @override
  String toString() {
    return 'AppConfig('
        'apiBaseUrl: $apiBaseUrl, '
        'apiTimeoutSeconds: $apiTimeoutSeconds, '
        'enableLogging: $enableLogging, '
        'isTestEnvironment: $isTestEnvironment, '
        'isDebugMode: $isDebugMode, '
        'appVersion: $appVersion, '
        'buildNumber: $buildNumber, '
        'featureFlags: $featureFlags'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is AppConfig &&
        other.apiBaseUrl == apiBaseUrl &&
        other.apiTimeoutSeconds == apiTimeoutSeconds &&
        other.enableLogging == enableLogging &&
        other.isTestEnvironment == isTestEnvironment &&
        other.isDebugMode == isDebugMode &&
        other.appVersion == appVersion &&
        other.buildNumber == buildNumber &&
        _mapEquals(other.featureFlags, featureFlags);
  }

  @override
  int get hashCode {
    return Object.hash(
      apiBaseUrl,
      apiTimeoutSeconds,
      enableLogging,
      isTestEnvironment,
      isDebugMode,
      appVersion,
      buildNumber,
      featureFlags,
    );
  }

  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}

/// Provider for app configuration
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.current;
});

/// Provider for feature flags
final featureFlagsProvider = Provider<Map<String, dynamic>>((ref) {
  final config = ref.watch(appConfigProvider);
  return config.featureFlags;
});

/// Provider for specific feature flag
Provider<bool> featureFlagProvider(String featureName) {
  return Provider<bool>((ref) {
    final config = ref.watch(appConfigProvider);
    return config.isFeatureEnabled(featureName);
  });
}