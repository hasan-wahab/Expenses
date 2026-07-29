import 'package:expense_app/core/data_source/local_image_source/image_source_repo.dart';
import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../utils/image_picker.dart';

class ImagePickerDiModule implements DIModule {
  GetIt sl;
  ImagePickerDiModule(this.sl);
  @override
  Future<void> init() async {
    sl
      ..registerLazySingleton<ImagePickerSource>(() => ImagePickerSource())
      ..registerLazySingleton<LocalImageSource>(
        () => LocalImageSource(imagePickerSource: sl<ImagePickerSource>()),
      );
  }
}
