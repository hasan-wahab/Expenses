abstract class SyncDataStates {}

class SyncDataLoadingState extends SyncDataStates {}

class SyncDataLoadedState extends SyncDataStates {}

class SyncDataErrorState extends SyncDataStates {
  final String error;
  SyncDataErrorState(this.error);
}
