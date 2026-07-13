import 'dart:async';

import 'package:expense_app/features/sync_data/data/sync_repo.dart';

class SyncDataUseCases {
  SyncRepo syncRepo;
  SyncDataUseCases({required this.syncRepo});

  Future<void> syncDataCall() async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await syncRepo.syncData();
    });
  }
}
