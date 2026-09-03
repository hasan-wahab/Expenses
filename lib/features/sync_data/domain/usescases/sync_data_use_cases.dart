import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_app/features/sync_data/data/sync_repo.dart';

class SyncDataUseCases {
  SyncRepo syncRepo;
  SyncDataUseCases({required this.syncRepo});

  Timer? _timer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _syncing = false;
  bool _started = false;
  final _synced = StreamController<void>.broadcast();

  Stream<void> get onSynced => _synced.stream;

  /// Login / Home ke baad call karo. UI block nahi hota.
  Future<void> startBackgroundSync() async {
    if (_started) {
      unawaited(_runOnce());
      return;
    }
    _started = true;
    unawaited(_runOnce());
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        unawaited(_runOnce());
      }
    });
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      unawaited(_runOnce());
    });
  }

  Future<void> syncDataCall() => startBackgroundSync();

  Future<void> _runOnce() async {
    if (_syncing) return;
    _syncing = true;
    try {
      final changed = await syncRepo.syncAll();
      if (changed && !_synced.isClosed) {
        _synced.add(null);
      }
    } catch (_) {
    } finally {
      _syncing = false;
    }
  }

  void stopSync() {
    _timer?.cancel();
    _timer = null;
    _connectivitySub?.cancel();
    _connectivitySub = null;
    _started = false;
  }

  void dispose() {
    stopSync();
  }
}
