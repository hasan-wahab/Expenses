import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerSource {
  ImagePicker picker = ImagePicker();

  Future<File?> pickImageFormGallery() async {
    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } on Exception {
      rethrow;
    }
  }

  Future<File?> pickImageFormCamera() async {
    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } on Exception {
      rethrow;
    }
  }
}
