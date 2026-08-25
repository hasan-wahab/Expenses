import 'dart:io';

import 'package:expense_app/core/data_source/auth_data_source/auth_local_source.dart';
import 'package:expense_app/core/data_source/auth_data_source/auth_remote_source.dart';
import 'package:expense_app/core/data_source/local_image_source/image_source_repo.dart';
import 'package:expense_app/core/extensions/string_extension.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:expense_app/features/personal_info/domain/repo_inter/personal_info_inter.dart';
import 'package:expense_app/features/settings/domain/entitity/settings_entity.dart';
import 'package:image_picker/image_picker.dart';

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
    UserModel user = await authLocalSource.get(
      email: currentUserEmail.toString(),
    );

    /// Persist gallery/camera temp file into app local directory
    var imageUrl = entityModel.imageUrl.orEmpty;
    if (imageUrl.isNotEmpty && !imageUrl.isNetworkUrl) {
      final file = File(imageUrl);
      if (await file.exists()) {
        imageUrl = await imageSourceRepo.saveImageLocalDir(imageUrl);
      }
    }

    UserModel updatedUser = user.copyWith(
      name: entityModel.name,
      imageUrl: imageUrl,
      phone: entityModel.phone,
      updateAt: DateTime.now().toString(),
    );
    await authLocalSource.save(model: updatedUser);
    await authRemoteSource.update(
      model: updatedUser,
      currentUserEmail: currentUserEmail.toString(),
    );

    /// Keep Firebase Auth displayName in sync with personal info name
    final name = entityModel.name?.trim();
    if (name != null && name.isNotEmpty) {
      await authRemoteSource.updateDisplayName(name);
    }
  }
}
