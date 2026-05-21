import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error categories for consistent handling across the app
enum ErrorCategory {
  network,
  authentication,
  authorization,
  validation,
  notFound,
  conflict,
  rateLimit,
  server,
  offline,
  unknown,
}

/// Standardized error class for the application
class AppError {
  final ErrorCategory category;
  final String code;
  final String message;
  final String? userMessage;
  final Map<String, dynamic>? details;
  final DateTime timestamp;
  final String? requestId;
  final bool isRetryable;
  final Duration? retryAfter;

  AppError({
    required this.category,
    required this.code,
    required this.message,
    this.userMessage,
    this.details,
    DateTime? timestamp,
    this.requestId,
    this.isRetryable = false,
    this.retryAfter,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create error from API response
  factory AppError.fromApiResponse(Map<String, dynamic> response) {
    final error = response['error'] as Map<String, dynamic>? ?? {};
    
    return AppError(
      category: _mapErrorCategory(error['code'] as String?),
      code: error['code'] as String? ?? 'UNKNOWN_ERROR',
      message: error['message'] as String? ?? 'An unknown error occurred',
      userMessage: error['message'] as String?,
      details: error['details'] as Map<String, dynamic>?,
      timestamp: DateTime.tryParse(error['timestamp'] as String? ?? '') ?? DateTime.now(),
      requestId: error['requestId'] as String?,
      isRetryable: _isRetryableError(error['code'] as String?),
    );
  }

  /// Create error from Dio exception
  factory AppError.fromDioException(DioException exception) {
    final response = exception.response;
    
    if (response?.data is Map<String, dynamic>) {
      try {
        return AppError.fromApiResponse(response!.data as Map<String, dynamic>);
      } catch (e) {
        // Fall through to generic handling
      }
    }

    return AppError(
      category: _mapDioErrorCategory(exception.type),
      code: exception.type.name.toUpperCase(),
      message: exception.message ?? 'Network error occurred',
      userMessage: _getUserFriendlyMessage(exception),
      isRetryable: _isDioErrorRetryable(exception.type),
      retryAfter: _getRetryAfter(exception),
    );
  }

  /// Create error from generic exception
  factory AppError.fromException(Object exception, [StackTrace? stackTrace]) {
    return AppError(
      category: ErrorCategory.unknown,
      code: 'UNKNOWN_ERROR',
      message: exception.toString(),
      userMessage: 'An unexpected error occurred. Please try again.',
      isRetryable: false,
    );
  }

  /// Create offline error
  factory AppError.offline() {
    return AppError(
      category: ErrorCategory.offline,
      code: 'OFFLINE_ERROR',
      message: 'No internet connection',
      userMessage: 'You appear to be offline. Please check your internet connection.',
      isRetryable: true,
    );
  }

  /// Create validation error
  factory AppError.validation(String message, [Map<String, dynamic>? details]) {
    return AppError(
      category: ErrorCategory.validation,
      code: 'VALIDATION_ERROR',
      message: message,
      userMessage: message,
      details: details,
      isRetryable: false,
    );
  }

  static ErrorCategory _mapErrorCategory(String? code) {
    if (code == null) return ErrorCategory.unknown;
    
    switch (code) {
      case 'AUTHENTICATION_ERROR':
        return ErrorCategory.authentication;
      case 'AUTHORIZATION_ERROR':
        return ErrorCategory.authorization;
      case 'VALIDATION_ERROR':
        return ErrorCategory.validation;
      case 'NOT_FOUND_ERROR':
        return ErrorCategory.notFound;
      case 'CONFLICT_ERROR':
        return ErrorCategory.conflict;
      case 'RATE_LIMIT_ERROR':
        return ErrorCategory.rateLimit;
      case 'DATABASE_ERROR':
      case 'INTERNAL_SERVER_ERROR':
        return ErrorCategory.server;
      default:
        return ErrorCategory.unknown;
    }
  }

  static ErrorCategory _mapDioErrorCategory(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return ErrorCategory.network;
      case DioExceptionType.badResponse:
        return ErrorCategory.server;
      case DioExceptionType.cancel:
        return ErrorCategory.unknown;
      case DioExceptionType.unknown:
        return ErrorCategory.network;
      default:
        return ErrorCategory.unknown;
    }
  }

  static bool _isRetryableError(String? code) {
    const retryableCodes = {
      'RATE_LIMIT_ERROR',
      'DATABASE_ERROR',
      'INTERNAL_SERVER_ERROR',
      'EXTERNAL_SERVICE_ERROR',
    };
    return retryableCodes.contains(code);
  }

  static bool _isDioErrorRetryable(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      default:
        return false;
    }
  }

  static String _getUserFriendlyMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to the server. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        if (statusCode == 401) {
          return 'Authentication failed. Please log in again.';
        } else if (statusCode == 403) {
          return 'You do not have permission to access this resource.';
        } else if (statusCode == 404) {
          return 'The requested resource was not found.';
        } else if (statusCode == 429) {
          return 'Too many requests. Please wait before trying again.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return 'An error occurred while processing your request.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  static Duration? _getRetryAfter(DioException exception) {
    final retryAfterHeader = exception.response?.headers['retry-after']?.first;
    if (retryAfterHeader != null) {
      final seconds = int.tryParse(retryAfterHeader);
      if (seconds != null) {
        return Duration(seconds: seconds);
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'AppError(category: $category, code: $code, message: $message)';
  }
}

/// Error recovery strategies
enum ErrorRecoveryStrategy {
  retry,
  refresh,
  login,
  goBack,
  goHome,
  ignore,
}

/// Error recovery action
class ErrorRecoveryAction {
  final String label;
  final ErrorRecoveryStrategy strategy;
  final VoidCallback? onTap;
  final bool isPrimary;

  const ErrorRecoveryAction({
    required this.label,
    required this.strategy,
    this.onTap,
    this.isPrimary = false,
  });
}

/// Global error handler service
class ErrorHandlerService {
  static final ErrorHandlerService _instance = ErrorHandlerService._internal();
  factory ErrorHandlerService() => _instance;
  ErrorHandlerService._internal();

  static ErrorHandlerService get instance => _instance;

  final StreamController<AppError> _errorController = StreamController<AppError>.broadcast();
  final List<AppError> _errorHistory = [];
  final Map<String, int> _errorCounts = {};

  /// Stream of errors for global error handling
  Stream<AppError> get errorStream => _errorController.stream;

  /// Get error history
  List<AppError> get errorHistory => List.unmodifiable(_errorHistory);

  /// Handle an error globally
  void handleError(Object error, [StackTrace? stackTrace]) {
    final appError = _convertToAppError(error, stackTrace);
    
    // Add to history
    _errorHistory.add(appError);
    if (_errorHistory.length > 100) {
      _errorHistory.removeAt(0);
    }

    // Track error counts
    _errorCounts[appError.code] = (_errorCounts[appError.code] ?? 0) + 1;

    // Emit error
    _errorController.add(appError);

    // Log error
    _logError(appError, stackTrace);

    // Report to analytics (if configured)
    _reportError(appError, stackTrace);
  }

  /// Show error dialog with recovery options
  Future<void> showErrorDialog(
    BuildContext context,
    AppError error, {
    List<ErrorRecoveryAction>? customActions,
  }) async {
    final actions = customActions ?? _getDefaultRecoveryActions(error);
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_getErrorTitle(error.category)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error.userMessage ?? error.message),
            if (error.details != null && kDebugMode) ...[
              const SizedBox(height: 16),
              const Text('Debug Info:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                jsonEncode(error.details),
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ],
          ],
        ),
        actions: actions.map((action) => TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            action.onTap?.call();
          },
          child: Text(action.label),
        )).toList(),
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackbar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.userMessage ?? error.message),
        backgroundColor: _getErrorColor(error.category),
        action: error.isRetryable
            ? SnackBarAction(
                label: 'Retry',
                onPressed: () {
                  // Implement retry logic
                },
              )
            : null,
      ),
    );
  }

  /// Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    
    final recentErrors = _errorHistory
        .where((error) => error.timestamp.isAfter(last24Hours))
        .toList();

    final errorsByCategory = <ErrorCategory, int>{};
    for (final error in recentErrors) {
      errorsByCategory[error.category] = (errorsByCategory[error.category] ?? 0) + 1;
    }

    return {
      'totalErrors': _errorHistory.length,
      'recentErrors': recentErrors.length,
      'errorsByCategory': errorsByCategory.map((k, v) => MapEntry(k.name, v)),
      'topErrors': _errorCounts.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value))
          ..take(5),
    };
  }

  /// Clear error history
  void clearErrorHistory() {
    _errorHistory.clear();
    _errorCounts.clear();
  }

  AppError _convertToAppError(Object error, StackTrace? stackTrace) {
    if (error is AppError) {
      return error;
    } else if (error is DioException) {
      return AppError.fromDioException(error);
    } else {
      return AppError.fromException(error, stackTrace);
    }
  }

  void _logError(AppError error, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint('Error: ${error.code} - ${error.message}');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  void _reportError(AppError error, StackTrace? stackTrace) {
    // In a real app, integrate with crash reporting services like:
    // - Firebase Crashlytics
    // - Sentry
    // - Bugsnag
    
    // Example:
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  String _getErrorTitle(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
        return 'Connection Error';
      case ErrorCategory.authentication:
        return 'Authentication Error';
      case ErrorCategory.authorization:
        return 'Permission Error';
      case ErrorCategory.validation:
        return 'Invalid Input';
      case ErrorCategory.notFound:
        return 'Not Found';
      case ErrorCategory.conflict:
        return 'Conflict Error';
      case ErrorCategory.rateLimit:
        return 'Rate Limited';
      case ErrorCategory.server:
        return 'Server Error';
      case ErrorCategory.offline:
        return 'Offline';
      case ErrorCategory.unknown:
        return 'Error';
    }
  }

  Color _getErrorColor(ErrorCategory category) {
    switch (category) {
      case ErrorCategory.network:
      case ErrorCategory.offline:
        return Colors.orange;
      case ErrorCategory.authentication:
      case ErrorCategory.authorization:
        return Colors.red;
      case ErrorCategory.validation:
        return Colors.amber;
      case ErrorCategory.server:
        return Colors.red.shade700;
      default:
        return Colors.red;
    }
  }

  List<ErrorRecoveryAction> _getDefaultRecoveryActions(AppError error) {
    final actions = <ErrorRecoveryAction>[];

    if (error.isRetryable) {
      actions.add(const ErrorRecoveryAction(
        label: 'Retry',
        strategy: ErrorRecoveryStrategy.retry,
        isPrimary: true,
      ));
    }

    if (error.category == ErrorCategory.authentication) {
      actions.add(const ErrorRecoveryAction(
        label: 'Login',
        strategy: ErrorRecoveryStrategy.login,
        isPrimary: true,
      ));
    }

    actions.add(const ErrorRecoveryAction(
      label: 'OK',
      strategy: ErrorRecoveryStrategy.ignore,
    ));

    return actions;
  }

  void dispose() {
    _errorController.close();
  }
}

/// Global error boundary widget
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(AppError error)? errorBuilder;
  final void Function(AppError error)? onError;

  const ErrorBoundary({
    Key? key,
    required this.child,
    this.errorBuilder,
    this.onError,
  }) : super(key: key);

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  AppError? _error;

  @override
  void initState() {
    super.initState();
    
    // Listen to global errors
    ErrorHandlerService.instance.errorStream.listen((error) {
      if (mounted) {
        setState(() {
          _error = error;
        });
        widget.onError?.call(error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!) ?? _buildDefaultErrorWidget();
    }
    
    return widget.child;
  }

  Widget _buildDefaultErrorWidget() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error?.userMessage ?? _error?.message ?? 'An unexpected error occurred',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Riverpod providers for error handling
final errorHandlerProvider = Provider<ErrorHandlerService>((ref) {
  return ErrorHandlerService.instance;
});

final errorStreamProvider = StreamProvider<AppError>((ref) {
  final errorHandler = ref.watch(errorHandlerProvider);
  return errorHandler.errorStream;
});

final errorStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final errorHandler = ref.watch(errorHandlerProvider);
  return errorHandler.getErrorStatistics();
});

/// Extension for easy error handling in widgets
extension ErrorHandlingExtension on WidgetRef {
  void handleError(Object error, [StackTrace? stackTrace]) {
    read(errorHandlerProvider).handleError(error, stackTrace);
  }

  void showErrorDialog(BuildContext context, AppError error) {
    read(errorHandlerProvider).showErrorDialog(context, error);
  }

  void showErrorSnackbar(BuildContext context, AppError error) {
    read(errorHandlerProvider).showErrorSnackbar(context, error);
  }
}