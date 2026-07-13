import 'package:expense_app/features/dashboard/data/property_repo.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:image_picker/image_picker.dart';

import '../../../dashboard/data/models/property_card_model.dart';
import '../../data/images/image_source_repo.dart';

class AddPropertyUseCases {
  PropertyRepo propertyRepo;
  ImageSourceRepo imageSourceRepo;
  AddPropertyUseCases({
    required this.propertyRepo,
    required this.imageSourceRepo,
  });
  Future addPropertyCall({required DashboardCardEntity model}) async {
    await propertyRepo.save(model: PropertyModel.fromEntity(model));
  }

  Future<XFile?> galleryImageCall() async {
    return await imageSourceRepo.galleryImage();
  }

  Future<XFile?> cameraImageCall() async {
    return await imageSourceRepo.cameraImage();
  }

  Future<String> saveImageFileInLocalDirCall(String tempPath) async {
    return await imageSourceRepo.saveImageLocalDir(tempPath);
  }

  Future addNewCategoryCall({required String categoryName}) async {
    await propertyRepo.addNewCategory(categoryName: categoryName);
  }

  Future<List<String>> getCategoryListCall() async {
    return await propertyRepo.getCategoryList();
  }
}
