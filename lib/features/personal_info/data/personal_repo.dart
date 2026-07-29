import 'dart:math';

import 'package:expense_app/core/data_source/auth_data_source/auth_local_source.dart';
import 'package:expense_app/core/data_source/auth_data_source/auth_remote_source.dart';
import 'package:expense_app/core/data_source/local_image_source/image_source_repo.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/personal_info/domain/repo_inter/personal_info_inter.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class PersonalRepo implements PersonalInfoInter {
  LocalImageSource imageSourceRepo;
  AuthRemoteSource authRemoteSource;
  AuthLocalSource authLocalSource;
  PersonalRepo({
    required this.imageSourceRepo,
    required this.authLocalSource,
    required this.authRemoteSource,
  });
  @override
  Future<XFile?> pickImage({ImageSource? source}) async {
    if (source == ImageSource.gallery) {
      return await imageSourceRepo.galleryImage();
    } else {
      return await imageSourceRepo.cameraImage();
    }
  }

  @override
  Future<void> updateUser({required SettingsEntityModel entityModel}) async {
    String? currentUserEmail = await authLocalSource.getCurrentUserEmail();
    print(currentUserEmail);
    UserModel user = await authLocalSource.get(
      email: currentUserEmail.toString(),
    );
    UserModel updatedUser = user.copyWith(
      name: entityModel.name,
      imageUrl: entityModel.imageUrl,
      phone: entityModel.phone,
      updateAt: DateTime.now().toString(),
    );
    await authLocalSource.save(model: updatedUser);
    await authRemoteSource.update(
      model: updatedUser,
      currentUserEmail: currentUserEmail.toString(),
    );
  }
}
