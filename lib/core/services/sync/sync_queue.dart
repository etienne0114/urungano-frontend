import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'offline_sync_service.dart';

/// Robust sync queue management with priority ordering, retry mechanisms, and persistence
class SyncQueue {
  static const String _queueBoxName = 'sync_queue';
  static const String _completedBoxName = 'sync_completed';
  static const String _failedBoxName = 'sync_failed';
  
  Box<String>? _queueBox;
  Box<String>? _completedBox;
  Box<String>? _failedBox;
  
  bool _isInitialized = false;

  /// Initialize the sync queue with Hive storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _queueBox = await Hive.openBox<String>(_queueBoxName);
      _completedBox = await Hive.openBox<String>(_completedBoxName);
      _failedBox = await Hive.openBox<String>(_failedBoxName);
      
      _isInitialized = true;
      debugPrint('SyncQueue initialized successfully');
      
      // Clean up old completed operations (keep last 100)
      await _cleanupCompletedOperations();
      
    } catch (e) {
      debugPrint('Failed to initialize SyncQueue: $e');
      rethrow;
    }
  }

  /// Add an operation to the sync queue
  Future<void> enqueue(SyncOperation operation) async {
    _ensureInitialized();
    
    try {
      final key = _generateQueueKey(operation);
      final value = jsonEncode(operation.toJson());
      
      await _queueBox!.put(key, value);
      
      debugPrint('Queued operation: ${operation.type.name} (${operation.id})');
    } catch (e) {
      debugPrint('Failed to enqueue operation: $e');
      rethrow;
    }
  }

  /// Get all queued operations sorted by priority and timestamp
  Future<List<SyncOperation>> getOperations() async {
    _ensureInitialized();
    
    try {
      final operations = <SyncOperation>[];
      
      for (final key in _queueBox!.keys) {
        final value = _queueBox!.get(key);
        if (value != null) {
          try {
            final json = jsonDecode(value) as Map<String, dynamic>;
            final operation = SyncOperation.fromJson(json);
            operations.add(operation);
          } catch (e) {
            debugPrint('Failed to parse operation $key: $e');
            // Remove corrupted entry
            await _queueBox!.delete(key);
          }
        }
      }
      
      // Sort by priority (higher first) then by timestamp (older first)
      operations.sort((a, b) {
        final priorityComparison = b.priority.compareTo(a.priority);
        if (priorityComparison != 0) return priorityComparison;
        return a.timestamp.compareTo(b.timestamp);
      });
      
      return operations;
    } catch (e) {
      debugPrint('Failed to get operations: $e');
      return [];
    }
  }

  /// Mark an operation as completed and remove from queue
  Future<void> markCompleted(String operationId) async {
    _ensureInitialized();
    
    try {
      // Find and remove from queue
      final queueKey = _findOperationKey(operationId);
      if (queueKey != null) {
        final operationData = _queueBox!.get(queueKey);
        if (operationData != null) {
          // Move to completed box
          final completedKey = '${DateTime.now().millisecondsSinceEpoch}_$operationId';
          await _completedBox!.put(completedKey, operationData);
          
          // Remove from queue
          await _queueBox!.delete(queueKey);
          
          debugPrint('Marked operation as completed: $operationId');
        }
      }
    } catch (e) {
      debugPrint('Failed to mark operation as completed: $e');
    }
  }

  /// Mark an operation as failed and handle retry logic
  Future<void> markFailed(String operationId, String error, {bool shouldRetry = true}) async {
    _ensureInitialized();
    
    try {
      final queueKey = _findOperationKey(operationId);
      if (queueKey == null) return;
      
      final operationData = _queueBox!.get(queueKey);
      if (operationData == null) return;
      
      final json = jsonDecode(operationData) as Map<String, dynamic>;
      final operation = SyncOperation.fromJson(json);
      
      const maxRetries = 3;
      
      if (shouldRetry && operation.retryCount < maxRetries) {
        // Increment retry count and re-queue with exponential backoff
        final retryOperation = SyncOperation(
          id: operation.id,
          type: operation.type,
          data: operation.data,
          timestamp: DateTime.now().add(_calculateRetryDelay(operation.retryCount)),
          retryCount: operation.retryCount + 1,
          priority: operation.priority,
        );
        
        // Update in queue
        await _queueBox!.put(queueKey, jsonEncode(retryOperation.toJson()));
        
        debugPrint('Scheduled retry ${operation.retryCount + 1}/$maxRetries for operation: $operationId');
      } else {
        // Move to failed box
        final failedData = {
          ...json,
          'error': error,
          'failedAt': DateTime.now().toIso8601String(),
        };
        
        final failedKey = '${DateTime.now().millisecondsSinceEpoch}_$operationId';
        await _failedBox!.put(failedKey, jsonEncode(failedData));
        
        // Remove from queue
        await _queueBox!.delete(queueKey);
        
        debugPrint('Marked operation as permanently failed: $operationId');
      }
    } catch (e) {
      debugPrint('Failed to mark operation as failed: $e');
    }
  }

  /// Get current queue status
  Future<SyncQueueStatus> getStatus() async {
    _ensureInitialized();
    
    try {
      final totalOperations = _queueBox!.length;
      final operations = await getOperations();
      
      // Count pending operations (not scheduled for future retry)
      final now = DateTime.now();
      final pendingOperations = operations
          .where((op) => op.timestamp.isBefore(now) || op.timestamp.isAtSameMomentAs(now))
          .length;
      
      final failedOperations = _failedBox!.length;
      
      // Get last sync time from completed operations
      DateTime? lastSyncTime;
      if (_completedBox!.isNotEmpty) {
        final lastKey = _completedBox!.keys.cast<String>().reduce((a, b) => a.compareTo(b) > 0 ? a : b);
        final timestamp = int.tryParse(lastKey.split('_').first);
        if (timestamp != null) {
          lastSyncTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        }
      }
      
      // Calculate next scheduled sync (earliest operation timestamp)
      DateTime? nextScheduledSync;
      final futureOperations = operations.where((op) => op.timestamp.isAfter(now));
      if (futureOperations.isNotEmpty) {
        nextScheduledSync = futureOperations
            .map((op) => op.timestamp)
            .reduce((a, b) => a.isBefore(b) ? a : b);
      }
      
      return SyncQueueStatus(
        totalOperations: totalOperations,
        pendingOperations: pendingOperations,
        failedOperations: failedOperations,
        lastSyncTime: lastSyncTime,
        nextScheduledSync: nextScheduledSync,
      );
    } catch (e) {
      debugPrint('Failed to get queue status: $e');
      return const SyncQueueStatus(
        totalOperations: 0,
        pendingOperations: 0,
        failedOperations: 0,
      );
    }
  }

  /// Clear all operations from the queue
  Future<void> clear() async {
    _ensureInitialized();
    
    try {
      await _queueBox!.clear();
      debugPrint('Cleared sync queue');
    } catch (e) {
      debugPrint('Failed to clear sync queue: $e');
    }
  }

  /// Remove specific operation from queue
  Future<void> removeOperation(String operationId) async {
    _ensureInitialized();
    
    try {
      final queueKey = _findOperationKey(operationId);
      if (queueKey != null) {
        await _queueBox!.delete(queueKey);
        debugPrint('Removed operation from queue: $operationId');
      }
    } catch (e) {
      debugPrint('Failed to remove operation: $e');
    }
  }

  /// Get failed operations for manual retry or inspection
  Future<List<Map<String, dynamic>>> getFailedOperations() async {
    _ensureInitialized();
    
    try {
      final failedOps = <Map<String, dynamic>>[];
      
      for (final key in _failedBox!.keys) {
        final value = _failedBox!.get(key);
        if (value != null) {
          try {
            final json = jsonDecode(value) as Map<String, dynamic>;
            failedOps.add(json);
          } catch (e) {
            debugPrint('Failed to parse failed operation $key: $e');
          }
        }
      }
      
      return failedOps;
    } catch (e) {
      debugPrint('Failed to get failed operations: $e');
      return [];
    }
  }

  /// Retry a failed operation
  Future<void> retryFailedOperation(String operationId) async {
    _ensureInitialized();
    
    try {
      // Find in failed box
      String? failedKey;
      Map<String, dynamic>? failedData;
      
      for (final key in _failedBox!.keys.cast<String>()) {
        if (key.endsWith('_$operationId')) {
          failedKey = key;
          final value = _failedBox!.get(key);
          if (value != null) {
            failedData = jsonDecode(value) as Map<String, dynamic>;
          }
          break;
        }
      }
      
      if (failedKey != null && failedData != null) {
        // Create new operation with reset retry count
        final operation = SyncOperation(
          id: operationId,
          type: SyncOperationType.values.firstWhere((e) => e.name == failedData!['type']),
          data: Map<String, dynamic>.from(failedData['data'] as Map),
          timestamp: DateTime.now(),
          retryCount: 0,
          priority: failedData['priority'] as int? ?? 0,
        );
        
        // Add back to queue
        await enqueue(operation);
        
        // Remove from failed box
        await _failedBox!.delete(failedKey);
        
        debugPrint('Retrying failed operation: $operationId');
      }
    } catch (e) {
      debugPrint('Failed to retry operation: $e');
    }
  }

  /// Deduplicate operations based on type and key data
  Future<void> deduplicateOperations() async {
    _ensureInitialized();
    
    try {
      final operations = await getOperations();
      final seen = <String, SyncOperation>{};
      final toRemove = <String>[];
      
      for (final operation in operations) {
        final dedupeKey = _generateDeduplicationKey(operation);
        
        if (seen.containsKey(dedupeKey)) {
          final existing = seen[dedupeKey]!;
          
          // Keep the more recent operation or higher priority
          if (operation.timestamp.isAfter(existing.timestamp) || 
              operation.priority > existing.priority) {
            // Mark existing for removal
            final existingKey = _findOperationKey(existing.id);
            if (existingKey != null) {
              toRemove.add(existingKey);
            }
            seen[dedupeKey] = operation;
          } else {
            // Mark current for removal
            final currentKey = _findOperationKey(operation.id);
            if (currentKey != null) {
              toRemove.add(currentKey);
            }
          }
        } else {
          seen[dedupeKey] = operation;
        }
      }
      
      // Remove duplicates
      for (final key in toRemove) {
        await _queueBox!.delete(key);
      }
      
      if (toRemove.isNotEmpty) {
        debugPrint('Removed ${toRemove.length} duplicate operations');
      }
    } catch (e) {
      debugPrint('Failed to deduplicate operations: $e');
    }
  }

  /// Generate a unique queue key for an operation
  String _generateQueueKey(SyncOperation operation) {
    return '${operation.priority.toString().padLeft(3, '0')}_${operation.timestamp.millisecondsSinceEpoch}_${operation.id}';
  }

  /// Generate deduplication key based on operation type and data
  String _generateDeduplicationKey(SyncOperation operation) {
    switch (operation.type) {
      case SyncOperationType.progressUpdate:
        return 'progress_${operation.data['lessonSlug']}';
      case SyncOperationType.communityMessage:
        return 'message_${operation.data['circleSlug']}_${operation.data['text']?.hashCode}';
      case SyncOperationType.quizSubmission:
        return 'quiz_${operation.data['lessonSlug']}_${operation.data['timestamp']}';
      case SyncOperationType.profileUpdate:
        return 'profile_${operation.data['userId']}';
      case SyncOperationType.lessonCompletion:
        return 'completion_${operation.data['lessonSlug']}';
    }
  }

  /// Find operation key by operation ID
  String? _findOperationKey(String operationId) {
    for (final key in _queueBox!.keys.cast<String>()) {
      if (key.endsWith('_$operationId')) {
        return key;
      }
    }
    return null;
  }

  /// Calculate retry delay with exponential backoff
  Duration _calculateRetryDelay(int retryCount) {
    final baseDelay = 1000; // 1 second
    final maxDelay = 60000; // 1 minute
    final delay = min(baseDelay * pow(2, retryCount), maxDelay);
    
    // Add jitter to prevent thundering herd
    final jitter = Random().nextInt(1000);
    
    return Duration(milliseconds: delay.toInt() + jitter);
  }

  /// Clean up old completed operations
  Future<void> _cleanupCompletedOperations() async {
    try {
      final keys = _completedBox!.keys.cast<String>().toList();
      
      if (keys.length > 100) {
        // Sort by timestamp (oldest first)
        keys.sort((a, b) {
          final timestampA = int.tryParse(a.split('_').first) ?? 0;
          final timestampB = int.tryParse(b.split('_').first) ?? 0;
          return timestampA.compareTo(timestampB);
        });
        
        // Remove oldest entries, keep last 100
        final toRemove = keys.take(keys.length - 100);
        for (final key in toRemove) {
          await _completedBox!.delete(key);
        }
        
        debugPrint('Cleaned up ${toRemove.length} old completed operations');
      }
    } catch (e) {
      debugPrint('Failed to cleanup completed operations: $e');
    }
  }

  /// Ensure the queue is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('SyncQueue not initialized. Call initialize() first.');
    }
  }
}

/// Helper class for creating common sync operations
class SyncOperationFactory {
  /// Create a progress update operation
  static SyncOperation createProgressUpdate({
    required String lessonSlug,
    required int progress,
    required int currentChapter,
    required bool isCompleted,
    int priority = 5,
  }) {
    return SyncOperation(
      id: 'progress_${lessonSlug}_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.progressUpdate,
      data: {
        'lessonSlug': lessonSlug,
        'progress': progress,
        'currentChapter': currentChapter,
        'isCompleted': isCompleted,
      },
      timestamp: DateTime.now(),
      priority: priority,
    );
  }

  /// Create a community message operation
  static SyncOperation createCommunityMessage({
    required String circleSlug,
    required String text,
    required String lang,
    int priority = 3,
  }) {
    return SyncOperation(
      id: 'message_${circleSlug}_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.communityMessage,
      data: {
        'circleSlug': circleSlug,
        'text': text,
        'lang': lang,
      },
      timestamp: DateTime.now(),
      priority: priority,
    );
  }

  /// Create a quiz submission operation
  static SyncOperation createQuizSubmission({
    required String lessonSlug,
    required List<int> answers,
    int priority = 7,
  }) {
    return SyncOperation(
      id: 'quiz_${lessonSlug}_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.quizSubmission,
      data: {
        'lessonSlug': lessonSlug,
        'answers': answers,
        'timestamp': DateTime.now().toIso8601String(),
      },
      timestamp: DateTime.now(),
      priority: priority,
    );
  }

  /// Create a profile update operation
  static SyncOperation createProfileUpdate({
    required String userId,
    required Map<String, dynamic> updates,
    int priority = 4,
  }) {
    return SyncOperation(
      id: 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.profileUpdate,
      data: {
        'userId': userId,
        'updates': updates,
      },
      timestamp: DateTime.now(),
      priority: priority,
    );
  }

  /// Create a lesson completion operation
  static SyncOperation createLessonCompletion({
    required String lessonSlug,
    required DateTime completedAt,
    int priority = 6,
  }) {
    return SyncOperation(
      id: 'completion_${lessonSlug}_${DateTime.now().millisecondsSinceEpoch}',
      type: SyncOperationType.lessonCompletion,
      data: {
        'lessonSlug': lessonSlug,
        'completedAt': completedAt.toIso8601String(),
      },
      timestamp: DateTime.now(),
      priority: priority,
    );
  }
}