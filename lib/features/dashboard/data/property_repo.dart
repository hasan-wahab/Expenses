import 'package:expense_app/core/data_source/expense_data_source/expense_local_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';
import 'package:expense_app/features/dashboard/domain/repos_inter/property_repo_inter.dart';

class PropertyRepo implements PropertyRepoInter {
  PropertiesLocalSource propertiesLocalSource;
  ExpenseLocalSource expenseLocalSource;
  PropertiesRemoteSource propertiesRemoteSource;

  PropertyRepo({
    required this.propertiesLocalSource,
    required this.expenseLocalSource,
    required this.propertiesRemoteSource,
  });

  @override
  Future<dynamic> save({required PropertyModel model}) async {
    String currentUserEmail = await propertiesLocalSource.getCurrentUserEmail();
    await propertiesLocalSource.addNewProperty(
      model: model,
      currentUserEmail: currentUserEmail,
    );
  }

  @override
  Future<List<PropertyModel>> get() async {
    await _syncSharedCardsLocally();
    String currentUserEmail = await propertiesLocalSource.getCurrentUserEmail();
    List<PropertyModel> oldPropertiesList = await propertiesLocalSource
        .getPropertiesList(currentUserEmail: currentUserEmail);
    List<PropertyModel> newList = [];
    for (var element in oldPropertiesList) {
      if (!element.isDeleted) {
        newList.add(element);
      }
    }
    return newList;
  }

  Future<void> _syncSharedCardsLocally() async {
    try {
      if (!await InternetUtils.hasInternetAccess()) return;
      final email = await propertiesLocalSource.getCurrentUserEmail();
      final remoteShared = await propertiesRemoteSource.getSharedWithMe();
      final localList = await propertiesLocalSource.getPropertiesList(
        currentUserEmail: email,
      );
      final localShared = localList.where((e) => e.isSharedWithMe).toList();

      for (final local in localShared) {
        final stillShared = remoteShared.any(
          (remote) =>
              remote.ownerId == local.ownerId && remote.cardId == local.cardId,
        );
        if (!stillShared) {
          await propertiesLocalSource.deleteProperty(
            cardId: local.cardId,
            currentUserEmail: email,
            ownerId: local.ownerId,
            deleteLocalExpenses: true,
          );
        }
      }

      for (final remote in remoteShared) {
        await propertiesLocalSource.upsertProperty(
          model: remote,
          currentUserEmail: email,
        );
      }
    } catch (_) {}
  }

  @override
  Future<dynamic> update({
    required PropertyModel model,
    required String propertyCardId,
  }) async {
    String currentUserEmail = await propertiesLocalSource.getCurrentUserEmail();
    if (model.isSharedWithMe) {
      await propertiesRemoteSource.updatePropertyById(
        model: model,
        currentUserEmail: currentUserEmail,
        ownerUid: model.ownerId,
      );
      await propertiesLocalSource.upsertProperty(
        model: model,
        currentUserEmail: currentUserEmail,
      );
      return;
    }
    await propertiesLocalSource.updateProperty(
      model: model,
      currentUserEmail: currentUserEmail,
    );
  }

  @override
  Future<dynamic> delete({required PropertyModel model}) async {
    String currentUserEmail = await propertiesLocalSource.getCurrentUserEmail();
    if (model.isSharedWithMe) {
      await propertiesRemoteSource.deletePropertyById(
        cardId: model.cardId,
        currentUserEmail: currentUserEmail,
        ownerUid: model.ownerId,
      );
      await propertiesLocalSource.deleteProperty(
        cardId: model.cardId,
        currentUserEmail: currentUserEmail,
        ownerId: model.ownerId,
        deleteLocalExpenses: true,
      );
      return;
    }
    await propertiesLocalSource.updateProperty(
      model: model,
      currentUserEmail: currentUserEmail,
    );
  }

  @override
  Future<dynamic> addNewCategory({required String categoryName}) async {
    await propertiesLocalSource.addNewCategory(categoryName: categoryName);
  }

  @override
  Future<List<String>> getCategoryList() async {
    return await propertiesLocalSource.getCategoryList();
  }
}
