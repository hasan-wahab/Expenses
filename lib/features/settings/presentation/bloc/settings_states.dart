import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';

import '../../../../core/constant/enums.dart';

class SettingsStates {}

class SettingsDataStates extends SettingsStates {
  Status status;
  SettingsEntityModel entityModel;
  SettingsDataStates({required this.entityModel ,this.status = Status.initial});
}
