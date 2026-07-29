import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class PersonalInfoStates {}

class GetProfileImageState extends PersonalInfoStates {
  Status status;
  XFile? imagePath;
  String? message;
  GetProfileImageState({required this.status, this.message, this.imagePath});
}

class UpdatePersonalInfoState extends PersonalInfoStates {
  Status status;
  String? message;
  // SettingsEntityModel? entityModel;
  UpdatePersonalInfoState({required this.status, this.message,});
}
