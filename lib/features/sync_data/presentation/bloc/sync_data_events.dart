abstract class SyncDataEvents {}

class SyncDataEvent extends SyncDataEvents {
  bool isFingerPrint;
  SyncDataEvent({required this.isFingerPrint});
}
