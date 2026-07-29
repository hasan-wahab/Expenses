import 'package:image_picker/image_picker.dart';

import '../../../settings/domain/entitity/settings_entity.dart';

abstract class PersonalInfoInter {
  /// Pick Image
  Future<XFile?> pickImage({ImageSource? source});

  /// Update User
  Future<void> updateUser({required SettingsEntityModel entityModel});
}
