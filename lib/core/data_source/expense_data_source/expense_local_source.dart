import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';

import '../../constant/enums.dart';

class ExpenseLocalSource {
  SqfLiteCurd sqfLiteCurd;
  PropertiesLocalSource propertiesLocalSource;

  ExpenseLocalSource({
    required this.sqfLiteCurd,
    required this.propertiesLocalSource,
  });

  Future addNewExpense({
    required ExpenseModel model,
    bool updateMonthlyTotal = true,
  }) async {
    try {
      String currentUserEmail = await getCurrentUserEmail();
      await sqfLiteCurd.save(
        tableKey: TableKeys.expensesTable,
        value: {'email': currentUserEmail, ...model.toMap()},
      );

      // Sync/reinstall pull: property already has correct monthlyExpenses from Firebase
      if (!updateMonthlyTotal) return;

      /// Get property list
      List<PropertyModel> propertyModel = await propertiesLocalSource
          .getPropertiesList(currentUserEmail: currentUserEmail);

      /// Update property list with new amount and progress
      /// First we need to get all property
      for (var element in propertyModel) {
        /// Then we need to get all expenses and check if the property id is the same
        if (element.cardId == model.propertyCardId) {
          /// Then we update the property with new amount and progress
          final double newAmount =
              (element.monthlyExpenses ?? 0) + (model.amount ?? 0);
          final double percent = (newAmount / element.monthlyBudget) * 100;
          await propertiesLocalSource.updateProperty(
            model: element.copyWith(
              monthlyExpenses: newAmount,
              syncStatus: SyncStatus.pending,
              updateAt: DateTime.now().toString(),
              progress: percent,
            ),
            currentUserEmail: currentUserEmail,
          );
        }
      }
    } on Exception {
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getAllExpenses({String? propertyCardId}) async {
    try {
      String currentUserEmail = await getCurrentUserEmail();

      String where;
      List<String>? whereArgs;
      if (propertyCardId == null) {
        /// All Card Expenses
        where = 'email = ?';
        whereArgs = [currentUserEmail];
      } else {
        /// Just One Card Expenses
        where = 'email = ? AND propertyCardId = ?';
        whereArgs = [currentUserEmail, propertyCardId];
      }
      final result = await sqfLiteCurd.get(
        tableKey: TableKeys.expensesTable,
        where: where,
        whereArgs: whereArgs,
      );
      if (result.isEmpty) return [];
      return result.map((e) => ExpenseModel.fromMap(e)).toList();
    } on Exception {
      rethrow;
    }
  }

  Future updateExpense({
    required ExpenseModel model,
    required String currentUserEmail,
  }) async {
    try {
      await sqfLiteCurd.update(
        tableKey: TableKeys.expensesTable,
        value: model.toMap(),
        where: 'email=? AND expenseId=?',
        whereArgs: [currentUserEmail, model.id],
      );
    } on Exception {
      rethrow;
    }
  }

  Future<String> getCurrentUserEmail() async {
    String currentUserEmail = await sqfLiteCurd
        .get(tableKey: TableKeys.currentUserEmailTable)
        .then((value) => value.first['email']);
    return currentUserEmail;
  }
}
