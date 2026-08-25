import 'dart:async';

import 'package:expense_app/features/sync_data/data/sync_repo.dart';

class SyncDataUseCases {
  SyncRepo syncRepo;
  SyncDataUseCases({required this.syncRepo});
  Timer? _timer;
  bool firstTime = true;
  bool _syncing = false;

  Future<void> syncDataCall() async {
    _timer?.cancel();
    if (firstTime) {
      await syncRepo.syncPropertiesData();
      firstTime = false;
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_syncing) return;
      _syncing = true;
      try {
        await syncRepo.syncPropertiesData();
        await syncRepo.syncExpensesData();
      } finally {
        _syncing = false;
      }
    });
  }

  void stopSync() {
    _timer?.cancel();
    _timer = null;
    firstTime = true;
  }

  void dispose() {
    stopSync();
  }
}
