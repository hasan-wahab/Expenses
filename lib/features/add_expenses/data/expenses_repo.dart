import 'package:expense_app/core/constant/app_key/firebase_paths.dart';
import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/data_source/expense_data_source/expense_local_source.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';
import 'package:expense_app/features/dashboard/data/property_repo.dart';

import '../domain/repos_inter/expense_repo_inter.dart';

class ExpensesRepo implements ExpenseRepoInter {
  SqfLiteCurd sqfLiteCurd;
  ExpenseLocalSource expenseLocalSource;
  PropertyRepo propertyRepo;

  ExpensesRepo({
    required this.sqfLiteCurd,
    required this.expenseLocalSource,
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
    await expenseLocalSource.addNewExpense(
      model: model.copyWith(
        propertyOwnerId: isSharedWithMe ? (propertyOwnerUid ?? '') : '',
        isSharedWithMe: isSharedWithMe,
        createdById: FirebasePaths.currentUid,
        syncStatus: SyncStatus.pending.toString(),
      ),
    );
  }

  @override
  Future<List<PropertyModel>> getPropertyCard() async {
    return await propertyRepo.get();
  }
}
