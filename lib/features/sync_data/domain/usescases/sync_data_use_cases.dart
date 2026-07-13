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
      await syncRepo.syncData();
      firstTime = true;
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await syncRepo.syncData();
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
