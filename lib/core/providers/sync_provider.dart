import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api/sync_service.dart';
import '../services/connectivity_service.dart';

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier();
});

enum SyncStatus { idle, syncing, success, failure }

class SyncState {
  final SyncStatus status;
  final DateTime? lastSync;
  final String? error;

  SyncState({
    this.status = SyncStatus.idle,
    this.lastSync,
    this.error,
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSync,
    String? error,
  }) {
    return SyncState(
      status:   status   ?? this.status,
      lastSync: lastSync ?? this.lastSync,
      error:    error    ?? this.error,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier() : super(SyncState()) {
    startAutoSync();
  }

  Timer? _syncTimer;

  void startAutoSync() {
    // Initial sync
    syncNow();
    
    // Periodic sync every 15 minutes if online
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (_) async {
      final online = await ConnectivityService.check();
      if (online) {
        syncNow();
      }
    });
  }

  Future<void> syncNow() async {
    if (state.status == SyncStatus.syncing) return;

    state = state.copyWith(status: SyncStatus.syncing);
    
    try {
      await SyncService.performFullSync();
      state = state.copyWith(
        status: SyncStatus.success,
        lastSync: DateTime.now(),
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.failure,
        error: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
