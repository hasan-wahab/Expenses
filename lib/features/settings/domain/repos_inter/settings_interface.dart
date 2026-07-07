import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';

abstract class SettingsInterface {
  /// Use Enable finger print then user login with finger print
  Future addFingerPrint();

  /// User Disable the finger print then not allow to login with finger print
  Future removeFingerPrint();

  /// Get Finger print status Enable / disable
  Future<bool> getFingerPrint();

  /// Get User Profile data
  Future<SettingsEntityModel> settingsProfileCardData();
}
