abstract class SettingsEvents {}

class OnSettingsEvent extends SettingsEvents {
  bool? isFingerPrintEnable;
  OnSettingsEvent({this.isFingerPrintEnable});
}
