abstract class SyncDataStates {}

class SyncDataLoadingState extends SyncDataStates {
  double progress;
  SyncDataLoadingState({required this.progress});
}

class SyncDataLoadedState extends SyncDataStates {}

class SyncDataErrorState extends SyncDataStates {
  final String error;
  SyncDataErrorState(this.error);
}
