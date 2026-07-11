import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImagePickerSource {
  ImagePicker picker = ImagePicker();

  Future<XFile?> pickImageFormGallery() async {
    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return pickedFile;
      }
      return null;
    } on Exception {
      rethrow;
    }
  }

  Future<XFile?> pickImageFormCamera() async {
    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        return pickedFile;
      }
      return null;
    } on Exception {
      rethrow;
    }
  }

  /// Save image file in local directory
  Future<String> saveImageFileInLocalDir(String tempPath) async {
    final dir = await getApplicationDocumentsDirectory();

    /// Use a unique file name with date and time to avoid duplicate files
    final date = DateTime.now().millisecondsSinceEpoch.toString();
    final fileName = '${date}_${tempPath.split('/').last}';

    final newPath = '${dir.path}/$fileName';

    final newFile = await File(tempPath).copy(newPath);

    return newFile.path;
  }
}
