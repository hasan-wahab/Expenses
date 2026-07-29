import 'package:expense_app/features/personal_info/domain/repo_inter/personal_info_inter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../settings/domain/entitity/settings_entity.dart';
import '../../data/personal_repo.dart';

class PersonalUseCases {
  PersonalRepo personalRepo;

  PersonalUseCases({required this.personalRepo});

  Future<XFile?> pickImageCall({ImageSource? source}) async {
    return await personalRepo.pickImage(source: source);
  }

  Future<void> updateUser({required SettingsEntityModel entityModel}) async {
    return await personalRepo.updateUser(entityModel: entityModel);
  }
}
