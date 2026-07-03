abstract class NaveBarEvents {}

class NaveBarIndexEvent extends NaveBarEvents {
  final int index;
  NaveBarIndexEvent({required this.index});
}
