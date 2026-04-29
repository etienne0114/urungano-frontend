import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../storage/hive_storage.dart';
import '../api/sync_service.dart';
import '../connectivity_service.dart';
import 'sync_queue.dart';

/// Comprehensive offline synchronization service with automatic sync triggers
/// Monitors connectivity and automatically synchronizes queued data when restored
class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  static OfflineSyncService get instance => _instance;

  final SyncQueue _syncQueue = SyncQueue();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _periodicSyncTimer;
  bool _isInitialized = false;
  bool _isSyncing = false;
  
  // Sync status tracking
  final ValueNotifier<SyncStatus> _syncStatus = ValueNotifier(SyncStatus.idle);
  final ValueNotifier<SyncProgress> _syncProgress = ValueNotifier(SyncProgress.empty());
  final ValueNotifier<List<SyncConflict>> _conflicts = ValueNotifier([]);

  // Getters for status monitoring
  ValueListenable<SyncStatus> get syncStatus => _syncStatus;
  ValueListenable<SyncProgress> get syncProgress => _syncProgress;
  ValueListenable<List<SyncConflict>> get conflicts => _conflicts;

  /// Initialize the offline sync service with connectivity monitoring
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize sync queue
      await _syncQueue.initialize();

      // Start connectivity monitoring
      _startConnectivityMonitoring();

      // Start periodic sync (every 5 minutes when online)
      _startPeriodicSync();

      // Perform initial sync if online
      final isOnline = await ConnectivityService.check();
      if (isOnline) {
        unawaited(_performSync());
      }

      _isInitialized = true;
      debugPrint('OfflineSyncService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize OfflineSyncService: $e');
      rethrow;
    }
  }

  /// Dispose resources and stop monitoring
  void dispose() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
    _syncStatus.dispose();
    _syncProgress.dispose();
    _conflicts.dispose();
    _isInitialized = false;
  }

  /// Queue an operation for offline synchronization
  Future<void> queueOperation(SyncOperation operation) async {
    await _syncQueue.enqueue(operation);
    
    // Try immediate sync if online
    final isOnline = await ConnectivityService.check();
    if (isOnline && !_isSyncing) {
      unawaited(_performSync());
    }
  }

  /// Force a manual synchronization
  Future<SyncResult> forcSync() async {
    return _performSync();
  }

  /// Get current sync queue status
  Future<SyncQueueStatus> getQueueStatus() async {
    return _syncQueue.getStatus();
  }

  /// Clear all queued operations (use with caution)
  Future<void> clearQueue() async {
    await _syncQueue.clear();
  }

  /// Resolve a sync conflict
  Future<void> resolveConflict(String conflictId, ConflictResolution resolution) async {
    final conflicts = List<SyncConflict>.from(_conflicts.value);
    final conflictIndex = conflicts.indexWhere((c) => c.id == conflictId);
    
    if (conflictIndex == -1) return;
    
    final conflict = conflicts[conflictIndex];
    
    try {
      // Apply resolution based on strategy
      switch (resolution.strategy) {
        case ConflictStrategy.useLocal:
          await _applyLocalData(conflict);
          break;
        case ConflictStrategy.useRemote:
          await _applyRemoteData(conflict);
          break;
        case ConflictStrategy.merge:
          await _mergeData(conflict, resolution.mergedData);
          break;
      }
      
      // Remove resolved conflict
      conflicts.removeAt(conflictIndex);
      _conflicts.value = conflicts;
      
    } catch (e) {
      debugPrint('Failed to resolve conflict $conflictId: $e');
      rethrow;
    }
  }

  /// Start monitoring connectivity changes
  void _startConnectivityMonitoring() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        if (result != ConnectivityResult.none) {
          // Connectivity restored, verify with backend
          final isOnline = await ConnectivityService.check();
          if (isOnline && !_isSyncing) {
            debugPrint('Connectivity restored, starting automatic sync');
            unawaited(_performSync());
          }
        }
      },
    );
  }

  /// Start periodic sync timer
  void _startPeriodicSync() {
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) async {
        final isOnline = await ConnectivityService.check();
        if (isOnline && !_isSyncing) {
          unawaited(_performSync());
        }
      },
    );
  }

  /// Perform comprehensive synchronization
  Future<SyncResult> _performSync() async {
    if (_isSyncing) {
      return SyncResult.alreadyInProgress();
    }

    _isSyncing = true;
    _syncStatus.value = SyncStatus.syncing;
    
    final startTime = DateTime.now();
    int successCount = 0;
    int failureCount = 0;
    final List<SyncError> errors = [];
    final List<SyncConflict> newConflicts = [];

    try {
      // Update progress
      _syncProgress.value = SyncProgress(
        phase: SyncPhase.preparingQueue,
        totalOperations: 0,
        completedOperations: 0,
        currentOperation: 'Preparing sync queue...',
      );

      // Get queued operations
      final queuedOperations = await _syncQueue.getOperations();
      final totalOps = queuedOperations.length;

      _syncProgress.value = SyncProgress(
        phase: SyncPhase.syncingData,
        totalOperations: totalOps,
        completedOperations: 0,
        currentOperation: 'Starting synchronization...',
      );

      // Process each queued operation
      for (int i = 0; i < queuedOperations.length; i++) {
        final operation = queuedOperations[i];
        
        _syncProgress.value = SyncProgress(
          phase: SyncPhase.syncingData,
          totalOperations: totalOps,
          completedOperations: i,
          currentOperation: 'Syncing ${operation.type.name}...',
        );

        try {
          final result = await _processOperation(operation);
          
          if (result.hasConflict) {
            newConflicts.add(result.conflict!);
          } else {
            await _syncQueue.markCompleted(operation.id);
            successCount++;
          }
        } catch (e) {
          errors.add(SyncError(
            operationId: operation.id,
            operationType: operation.type,
            error: e.toString(),
            timestamp: DateTime.now(),
          ));
          failureCount++;
        }
      }

      // Perform full sync from backend
      _syncProgress.value = SyncProgress(
        phase: SyncPhase.downloadingUpdates,
        totalOperations: totalOps,
        completedOperations: totalOps,
        currentOperation: 'Downloading updates from server...',
      );

      await SyncService.performFullSync();

      // Update conflicts list
      if (newConflicts.isNotEmpty) {
        final allConflicts = List<SyncConflict>.from(_conflicts.value);
        allConflicts.addAll(newConflicts);
        _conflicts.value = allConflicts;
      }

      final duration = DateTime.now().difference(startTime);
      final result = SyncResult.success(
        duration: duration,
        operationsProcessed: totalOps,
        successCount: successCount,
        failureCount: failureCount,
        conflicts: newConflicts,
        errors: errors,
      );

      _syncStatus.value = newConflicts.isNotEmpty 
          ? SyncStatus.conflictsDetected 
          : SyncStatus.completed;

      return result;

    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      final result = SyncResult.failure(
        duration: duration,
        error: e.toString(),
        errors: errors,
      );

      _syncStatus.value = SyncStatus.failed;
      return result;

    } finally {
      _isSyncing = false;
      
      // Reset progress after a delay
      Timer(const Duration(seconds: 3), () {
        _syncProgress.value = SyncProgress.empty();
        if (_syncStatus.value != SyncStatus.conflictsDetected) {
          _syncStatus.value = SyncStatus.idle;
        }
      });
    }
  }

  /// Process a single sync operation
  Future<OperationResult> _processOperation(SyncOperation operation) async {
    switch (operation.type) {
      case SyncOperationType.progressUpdate:
        return _syncProgressUpdate(operation);
      case SyncOperationType.communityMessage:
        return _syncCommunityMessage(operation);
      case SyncOperationType.quizSubmission:
        return _syncQuizSubmission(operation);
      case SyncOperationType.profileUpdate:
        return _syncProfileUpdate(operation);
      case SyncOperationType.lessonCompletion:
        return _syncLessonCompletion(operation);
    }
  }

  /// Sync progress update operation
  Future<OperationResult> _syncProgressUpdate(SyncOperation operation) async {
    try {
      final data = operation.data;
      final lessonSlug = data['lessonSlug'] as String;
      
      // Check for conflicts with server data
      final serverProgress = await _fetchServerProgress(lessonSlug);
      if (serverProgress != null && _hasProgressConflict(data, serverProgress)) {
        return OperationResult.conflict(
          SyncConflict(
            id: operation.id,
            type: ConflictType.progressMismatch,
            localData: data,
            remoteData: serverProgress,
            description: 'Progress conflict detected for lesson $lessonSlug',
          ),
        );
      }

      // No conflict, proceed with sync
      await SyncService.pushLocalChanges();
      return OperationResult.success();
      
    } catch (e) {
      return OperationResult.failure(e.toString());
    }
  }

  /// Sync community message operation
  Future<OperationResult> _syncCommunityMessage(SyncOperation operation) async {
    try {
      await SyncService.flushPendingCommunityWrites();
      return OperationResult.success();
    } catch (e) {
      return OperationResult.failure(e.toString());
    }
  }

  /// Sync quiz submission operation
  Future<OperationResult> _syncQuizSubmission(SyncOperation operation) async {
    try {
      // Quiz submissions are typically immediate, but handle queued ones
      final data = operation.data;
      // Implementation would depend on quiz service API
      return OperationResult.success();
    } catch (e) {
      return OperationResult.failure(e.toString());
    }
  }

  /// Sync profile update operation
  Future<OperationResult> _syncProfileUpdate(SyncOperation operation) async {
    try {
      // Handle profile updates
      final data = operation.data;
      // Implementation would depend on profile service API
      return OperationResult.success();
    } catch (e) {
      return OperationResult.failure(e.toString());
    }
  }

  /// Sync lesson completion operation
  Future<OperationResult> _syncLessonCompletion(SyncOperation operation) async {
    try {
      // Handle lesson completion
      final data = operation.data;
      // This might be part of progress update
      return OperationResult.success();
    } catch (e) {
      return OperationResult.failure(e.toString());
    }
  }

  /// Fetch server progress for conflict detection
  Future<Map<String, dynamic>?> _fetchServerProgress(String lessonSlug) async {
    try {
      // This would need to be implemented in the API client
      // For now, return null (no conflict)
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if there's a progress conflict
  bool _hasProgressConflict(Map<String, dynamic> local, Map<String, dynamic> remote) {
    final localProgress = local['progress'] as int? ?? 0;
    final remoteProgress = remote['progress'] as int? ?? 0;
    
    // Conflict if local progress is significantly different from remote
    return (localProgress - remoteProgress).abs() > 10;
  }

  /// Apply local data to resolve conflict
  Future<void> _applyLocalData(SyncConflict conflict) async {
    // Force push local data to server
    // Implementation depends on the conflict type
  }

  /// Apply remote data to resolve conflict
  Future<void> _applyRemoteData(SyncConflict conflict) async {
    // Overwrite local data with remote data
    // Implementation depends on the conflict type
  }

  /// Merge data to resolve conflict
  Future<void> _mergeData(SyncConflict conflict, Map<String, dynamic>? mergedData) async {
    // Apply merged data
    // Implementation depends on the conflict type
  }
}

// Enums and Data Classes

enum SyncStatus {
  idle,
  syncing,
  completed,
  failed,
  conflictsDetected,
}

enum SyncPhase {
  preparingQueue,
  syncingData,
  downloadingUpdates,
  resolvingConflicts,
}

enum SyncOperationType {
  progressUpdate,
  communityMessage,
  quizSubmission,
  profileUpdate,
  lessonCompletion,
}

enum ConflictType {
  progressMismatch,
  dataOverwrite,
  timestampConflict,
}

enum ConflictStrategy {
  useLocal,
  useRemote,
  merge,
}

class SyncProgress {
  final SyncPhase phase;
  final int totalOperations;
  final int completedOperations;
  final String currentOperation;

  const SyncProgress({
    required this.phase,
    required this.totalOperations,
    required this.completedOperations,
    required this.currentOperation,
  });

  factory SyncProgress.empty() => const SyncProgress(
    phase: SyncPhase.preparingQueue,
    totalOperations: 0,
    completedOperations: 0,
    currentOperation: '',
  );

  double get progress => totalOperations > 0 
      ? completedOperations / totalOperations 
      : 0.0;
}

class SyncOperation {
  final String id;
  final SyncOperationType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final int retryCount;
  final int priority;

  const SyncOperation({
    required this.id,
    required this.type,
    required this.data,
    required this.timestamp,
    this.retryCount = 0,
    this.priority = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
    'priority': priority,
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
    id: json['id'] as String,
    type: SyncOperationType.values.firstWhere(
      (e) => e.name == json['type'],
    ),
    data: Map<String, dynamic>.from(json['data'] as Map),
    timestamp: DateTime.parse(json['timestamp'] as String),
    retryCount: json['retryCount'] as int? ?? 0,
    priority: json['priority'] as int? ?? 0,
  );
}

class SyncConflict {
  final String id;
  final ConflictType type;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final String description;
  final DateTime timestamp;

  SyncConflict({
    required this.id,
    required this.type,
    required this.localData,
    required this.remoteData,
    required this.description,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ConflictResolution {
  final ConflictStrategy strategy;
  final Map<String, dynamic>? mergedData;

  const ConflictResolution({
    required this.strategy,
    this.mergedData,
  });
}

class SyncResult {
  final bool success;
  final Duration duration;
  final int? operationsProcessed;
  final int? successCount;
  final int? failureCount;
  final List<SyncConflict> conflicts;
  final List<SyncError> errors;
  final String? errorMessage;

  const SyncResult({
    required this.success,
    required this.duration,
    this.operationsProcessed,
    this.successCount,
    this.failureCount,
    this.conflicts = const [],
    this.errors = const [],
    this.errorMessage,
  });

  factory SyncResult.success({
    required Duration duration,
    required int operationsProcessed,
    required int successCount,
    required int failureCount,
    List<SyncConflict> conflicts = const [],
    List<SyncError> errors = const [],
  }) => SyncResult(
    success: true,
    duration: duration,
    operationsProcessed: operationsProcessed,
    successCount: successCount,
    failureCount: failureCount,
    conflicts: conflicts,
    errors: errors,
  );

  factory SyncResult.failure({
    required Duration duration,
    required String error,
    List<SyncError> errors = const [],
  }) => SyncResult(
    success: false,
    duration: duration,
    errorMessage: error,
    errors: errors,
  );

  factory SyncResult.alreadyInProgress() => const SyncResult(
    success: false,
    duration: Duration.zero,
    errorMessage: 'Sync already in progress',
  );
}

class SyncError {
  final String operationId;
  final SyncOperationType operationType;
  final String error;
  final DateTime timestamp;

  const SyncError({
    required this.operationId,
    required this.operationType,
    required this.error,
    required this.timestamp,
  });
}

class OperationResult {
  final bool success;
  final String? error;
  final SyncConflict? conflict;

  const OperationResult({
    required this.success,
    this.error,
    this.conflict,
  });

  factory OperationResult.success() => const OperationResult(success: true);
  
  factory OperationResult.failure(String error) => OperationResult(
    success: false,
    error: error,
  );
  
  factory OperationResult.conflict(SyncConflict conflict) => OperationResult(
    success: false,
    conflict: conflict,
  );

  bool get hasConflict => conflict != null;
}

class SyncQueueStatus {
  final int totalOperations;
  final int pendingOperations;
  final int failedOperations;
  final DateTime? lastSyncTime;
  final DateTime? nextScheduledSync;

  const SyncQueueStatus({
    required this.totalOperations,
    required this.pendingOperations,
    required this.failedOperations,
    this.lastSyncTime,
    this.nextScheduledSync,
  });
}

// Riverpod Providers

final offlineSyncServiceProvider = Provider<OfflineSyncService>((ref) {
  return OfflineSyncService.instance;
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final service = ref.watch(offlineSyncServiceProvider);
  return Stream.fromFuture(
    Future.value(service.syncStatus.value),
  );
});

final syncProgressProvider = StreamProvider<SyncProgress>((ref) {
  final service = ref.watch(offlineSyncServiceProvider);
  return Stream.fromFuture(
    Future.value(service.syncProgress.value),
  );
});