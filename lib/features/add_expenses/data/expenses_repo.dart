import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/constant/const_text/share_property_text.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/data_source/expense_data_source/expense_local_source.dart';
import 'package:expense_app/core/data_source/expense_data_source/expense_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';
import 'package:expense_app/features/dashboard/data/property_repo.dart';

import '../domain/repos_inter/expense_repo_inter.dart';

class ExpensesRepo implements ExpenseRepoInter {
  SqfLiteCurd sqfLiteCurd;
  ExpenseLocalSource expenseLocalSource;
  PropertiesLocalSource propertiesLocalSource;
  ExpenseRemoteSource expenseRemoteSource;
  PropertiesRemoteSource propertiesRemoteSource;
  PropertyRepo propertyRepo;

  ExpensesRepo({
    required this.sqfLiteCurd,
    required this.expenseLocalSource,
    required this.propertiesLocalSource,
    required this.expenseRemoteSource,
    required this.propertiesRemoteSource,
    required this.propertyRepo,
  });

  @override
  Future addNewCategory(String categoryName) async {
    await sqfLiteCurd.save(
      tableKey: TableKeys.categoryTable,
      value: {'categoryName': categoryName},
    );
  }

  @override
  Future<List<String>> getCategories() async {
    final result = await sqfLiteCurd.get(tableKey: TableKeys.categoryTable);
    List<String> items = [];
    if (result.isEmpty) return [];
    for (var element in result) {
      items.add(element['categoryName']);
    }
    return items;
  }

  @override
  Future<dynamic> addNewExpense({
    required ExpenseModel model,
    String? propertyOwnerUid,
    bool isSharedWithMe = false,
  }) async {
    final localModel = model.copyWith(
      propertyOwnerId: isSharedWithMe ? (propertyOwnerUid ?? '') : '',
      isSharedWithMe: isSharedWithMe,
    );

    if (isSharedWithMe) {
      final ownerUid = propertyOwnerUid ?? '';
      final hasNet = await InternetUtils.hasInternetAccess();
      if (hasNet) {
        final allowed = await propertiesRemoteSource.canMemberAddExpense(
          ownerUid: ownerUid,
          cardId: localModel.propertyCardId ?? 0,
        );
        if (!allowed) {
          final email = await propertiesLocalSource.getCurrentUserEmail();
          await propertiesLocalSource.deleteProperty(
            cardId: localModel.propertyCardId ?? 0,
            currentUserEmail: email,
            ownerId: ownerUid,
            deleteLocalExpenses: true,
          );
          throw SharePropertyText.accessRemovedCannotAdd;
        }
      }

      await expenseLocalSource.addNewExpense(model: localModel);

      if (hasNet) {
        await expenseRemoteSource.addNewExpense(
          model: localModel,
          propertyOwnerUid: ownerUid,
        );
        final email = await propertiesLocalSource.getCurrentUserEmail();
        await expenseLocalSource.updateExpense(
          model: localModel.copyWith(
            syncStatus: SyncStatus.synced.toString(),
          ),
          currentUserEmail: email,
        );
      }
      return;
    }

    await expenseLocalSource.addNewExpense(model: localModel);
  }

  @override
  Future<List<PropertyModel>> getPropertyCard() async {
    return await propertyRepo.get();
  }
}
