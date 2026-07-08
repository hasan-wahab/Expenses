import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:expense_app/core/utils/image_picker.dart';

class ImageSourceRepo {
  ImagePickerSource imagePickerSource;
  ImageSourceRepo({required this.imagePickerSource});

  Future<File?> galleryImage() async {
    try {
      return await imagePickerSource.pickImageFormGallery();
    } on Exception {
      rethrow;
    }
  }

  Future<File?> cameraImage() async {
    try {
      return await imagePickerSource.pickImageFormCamera();
    } on Exception {
      rethrow;
    }
  }
}
