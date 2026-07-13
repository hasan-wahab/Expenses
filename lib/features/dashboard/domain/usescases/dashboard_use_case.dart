import 'package:expense_app/features/dashboard/data/property_repo.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';

import '../../data/models/property_card_model.dart';

class DashboardUseCase {
  PropertyRepo propertyRepo;
  DashboardUseCase({required this.propertyRepo});

  Future<List<DashboardCardEntity>> getPropertiesListCall() async {
    List<PropertyModel> list = await propertyRepo.get();
    List<DashboardCardEntity> newList = [];
    for (var element in list) {
      if (element.isDeleted == false) {
        newList.add(element.toEntity());
      }
    }
    return newList;
  }

  Future deletePropertyCall({required PropertyModel model}) async {
    await propertyRepo.delete(model: model);
  }

  Future updatePropertyCall({
    required PropertyModel model,
    required String propertyCardId,
  }) async {
    await propertyRepo.update(model: model, propertyCardId: propertyCardId);
  }
}
