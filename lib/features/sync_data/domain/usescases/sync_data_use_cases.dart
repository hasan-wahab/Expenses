import 'dart:async';

import 'package:expense_app/features/sync_data/data/sync_repo.dart';

class SyncDataUseCases {
  SyncRepo syncRepo;
  SyncDataUseCases({required this.syncRepo});
  Timer? _timer;
  bool firstTime = true;
  Future<void> syncDataCall() async {
    _timer?.cancel();
    if (firstTime) {
      await syncRepo.syncPropertiesData();
      firstTime = false;
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await syncRepo.syncPropertiesData();
      await syncRepo.syncExpensesData();
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
