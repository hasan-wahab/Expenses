import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/internet_utils.dart';
import '../../../dashboard/data/local.dart';
import '../../../dashboard/data/models/dashboard_card_model.dart';
import '../../../dashboard/domain/entitity/dashboard_card_entity.dart';
import '../../../dashboard/domain/repos_inter/dashboard_repo_inter.dart';
import '../../data/images/image_source_repo.dart';

class AddPropertyUseCases {
  ImageSourceRepo imageSourceRepo;
  DashboardRepoInter dashboardRepoInter;
  DashboardLocal local;
  AddPropertyUseCases({
    required this.imageSourceRepo,
    required this.dashboardRepoInter,
    required this.local,
  });

  Future<XFile?> galleryImage() async {
    return await imageSourceRepo.galleryImage();
  }

  Future<XFile?> cameraImage() async {
    return await imageSourceRepo.cameraImage();
  }

  /// Save Image File in local Dir storage
  Future<String> saveImageFileInLocalDir(String tempPath) async {
    return await imageSourceRepo.saveImageLocalDir(tempPath);
  }

  /// Save Property
  Future saveProperty({required DashboardCardEntity model}) async {
    /// Check Internet Connection
    if (await InternetUtils.isInternetAvailable()) {
      /// Save Property in Firebase
      await dashboardRepoInter.save(
        model: DashboardCardModel.fromEntity(model),
      );

      /// Save Property in Local Storage
      await local.addNewPropertyCard(
        model: DashboardCardModel.fromEntity(model),
      );
    } else {
      /// Save Property in Local Storage => if no internet connection
      await local.addNewPropertyCard(
        model: DashboardCardModel.fromEntity(model),
      );
    }
  }
}
