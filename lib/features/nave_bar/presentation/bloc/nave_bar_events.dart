abstract class NaveBarEvents {}

class NaveBarIndexEvent extends NaveBarEvents {
  final int index;
  NaveBarIndexEvent({required this.index});
}

class NaveBarRefreshHomeEvent extends NaveBarEvents {}

class NaveBarSyncHomeEvent extends NaveBarEvents {}
