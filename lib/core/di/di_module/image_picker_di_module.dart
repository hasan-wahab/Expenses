import 'package:expense_app/core/di/di_module/di_module.dart';
import 'package:get_it/get_it.dart';

import '../../../features/add_property/data/images/image_source_repo.dart';
import '../../utils/image_picker.dart';

class ImagePickerDiModule implements DIModule{
  GetIt  sl;
  ImagePickerDiModule(this.sl);
  @override
  Future<void> init()async {
    sl
      ..registerLazySingleton<ImagePickerSource>(() => ImagePickerSource())
      ..registerLazySingleton<ImageSourceRepo>(
            () => ImageSourceRepo(imagePickerSource: sl<ImagePickerSource>()),
      );
  }
}