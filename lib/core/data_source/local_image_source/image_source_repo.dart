import 'dart:io';
import 'package:expense_app/core/utils/image_picker.dart';
import 'package:image_picker/image_picker.dart';

class LocalImageSource {
  ImagePickerSource imagePickerSource;
  LocalImageSource({required this.imagePickerSource});

  Future<XFile?> galleryImage() async {
    try {
      return await imagePickerSource.pickImageFormGallery();
    } on Exception {
      rethrow;
    }
  }

  Future<XFile?> cameraImage() async {
    try {
      return await imagePickerSource.pickImageFormCamera();
    } on Exception {
      rethrow;
    }
  }

  Future<String> saveImageLocalDir(String tempPath) async {
    try {
      return await imagePickerSource.saveImageFileInLocalDir(tempPath);
    } on Exception {
      rethrow;
    }
  }
}
