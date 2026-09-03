import 'package:expense_app/core/constant/app_key/firebase_paths.dart';
import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';
import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';
import 'package:sqflite/sqflite.dart';

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
      final withCreator = model.copyWith(
        createdById: (model.createdById ?? '').isNotEmpty
            ? model.createdById
            : FirebasePaths.currentUid,
      );
      await sqfLiteCurd.save(
        tableKey: TableKeys.expensesTable,
        value: {'email': currentUserEmail, ...withCreator.toMap()},
      );

      if (!updateMonthlyTotal) return;

      List<PropertyModel> propertyModel = await propertiesLocalSource
          .getPropertiesList(currentUserEmail: currentUserEmail);

      final expenseOwnerKey = model.propertyOwnerId ?? '';
      for (var element in propertyModel) {
        if (element.cardId != model.propertyCardId) continue;
        final propertyOwnerKey = element.ownerId ?? '';
        final sameOwner = propertyOwnerKey == expenseOwnerKey;
        final sharedSameCard =
            model.isSharedWithMe &&
            element.isSharedWithMe &&
            (expenseOwnerKey.isEmpty || expenseOwnerKey == propertyOwnerKey);
        if (!sameOwner && !sharedSameCard) continue;

        final double newAmount =
            (element.monthlyExpenses ?? 0) + (model.amount ?? 0);
        final double percent = element.monthlyBudget == 0
            ? 0
            : (newAmount / element.monthlyBudget) * 100;
        await propertiesLocalSource.updateProperty(
          model: element.copyWith(
            monthlyExpenses: newAmount,
            syncStatus: element.isSharedWithMe
                ? element.syncStatus
                : SyncStatus.pending,
            updateAt: DateTime.now().toString(),
            progress: percent,
          ),
          currentUserEmail: currentUserEmail,
        );
      }
    } on Exception {
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getAllExpenses({
    String? propertyCardId,
    String? propertyOwnerId,
  }) async {
    try {
      String currentUserEmail = await getCurrentUserEmail();

      String where;
      List<Object> whereArgs;
      if (propertyCardId == null) {
        where = 'email = ?';
        whereArgs = [currentUserEmail];
      } else if (propertyOwnerId != null) {
        where =
            'email = ? AND propertyCardId = ? AND IFNULL(propertyOwnerId, "") = ?';
        whereArgs = [currentUserEmail, propertyCardId, propertyOwnerId];
      } else {
        where = 'email = ? AND propertyCardId = ?';
        whereArgs = [currentUserEmail, propertyCardId];
      }
      final result = await sqfLiteCurd.get(
        tableKey: TableKeys.expensesTable,
        where: where,
        whereArgs: whereArgs.map((e) => e.toString()).toList(),
      );
      if (result.isEmpty) return [];
      return result.map((e) => ExpenseModel.fromMap(e)).toList();
    } on Exception {
      rethrow;
    }
  }

  /// Returns true only when a row was inserted or content actually changed.
  Future<bool> upsertExpense({required ExpenseModel model}) async {
    try {
      final currentUserEmail = await getCurrentUserEmail();
      final createdBy = model.createdById ?? '';
      final existing = await sqfLiteCurd.get(
        tableKey: TableKeys.expensesTable,
        where:
            'email = ? AND expenseId = ? AND propertyCardId = ? AND (IFNULL(createdById, "") = ? OR IFNULL(createdById, "") = "")',
        whereArgs: [
          currentUserEmail,
          '${model.id ?? 0}',
          '${model.propertyCardId ?? 0}',
          createdBy,
        ],
      );

      Map<String, dynamic>? match;
      for (final row in existing) {
        final rowCreator = (row['createdById'] ?? '').toString();
        if (rowCreator == createdBy) {
          match = row;
          break;
        }
      }
      match ??= existing.isEmpty ? null : existing.first;

      final payload = {'email': currentUserEmail, ...model.toMap()};
      if (match != null) {
        if (_sameExpenseContent(match, model)) return false;
        await sqfLiteCurd.update(
          tableKey: TableKeys.expensesTable,
          value: payload,
          where: 'id = ?',
          whereArgs: [match['id']],
        );
        return true;
      }

      await sqfLiteCurd.save(
        tableKey: TableKeys.expensesTable,
        value: payload,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } on Exception {
      rethrow;
    }
  }

  bool _sameExpenseContent(Map<String, dynamic> row, ExpenseModel model) {
    bool sameNum(num? a, num? b) => ((a ?? 0) - (b ?? 0)).abs() < 0.009;
    return '${row['title'] ?? ''}' == (model.title ?? '') &&
        sameNum(row['amount'] as num?, model.amount) &&
        '${row['categoryType'] ?? ''}' == (model.categoryType ?? '') &&
        '${row['date'] ?? ''}' == (model.date ?? '') &&
        '${row['note'] ?? ''}' == (model.note ?? '') &&
        (row['isDeleted'] == 1 ? 1 : 0) == (model.isDeleted ?? 0) &&
        '${row['propertyOwnerId'] ?? ''}' == (model.propertyOwnerId ?? '') &&
        '${row['createdById'] ?? ''}' == (model.createdById ?? '');
  }

  /// Removes copied remote rows that sat next to the original local expense.
  /// Returns card ids that had duplicates so only those totals are rebuilt.
  Future<Set<int>> removeDuplicateExpenses() async {
    final currentUserEmail = await getCurrentUserEmail();
    final rows = await sqfLiteCurd.get(
      tableKey: TableKeys.expensesTable,
      where: 'email = ?',
      whereArgs: [currentUserEmail],
    );
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final key = '${row['expenseId']}_${row['propertyCardId']}';
      groups.putIfAbsent(key, () => []).add(row);
    }

    final affectedCardIds = <int>{};
    for (final group in groups.values) {
      if (group.length < 2) continue;
      final keepIds = <int>{};
      final byCreator = <String, Map<String, dynamic>>{};
      for (final row in group) {
        final creator = (row['createdById'] ?? '').toString();
        if (creator.isEmpty) continue;
        final current = byCreator[creator];
        final rowId = row['id'] as int;
        if (current == null || rowId > (current['id'] as int)) {
          byCreator[creator] = row;
        }
      }
      if (byCreator.isEmpty) {
        var best = group.first;
        for (final row in group) {
          if ((row['id'] as int) > (best['id'] as int)) best = row;
        }
        keepIds.add(best['id'] as int);
      } else {
        keepIds.addAll(byCreator.values.map((e) => e['id'] as int));
      }

      for (final row in group) {
        final id = row['id'] as int;
        if (keepIds.contains(id)) continue;
        affectedCardIds.add(
          int.tryParse('${row['propertyCardId'] ?? 0}') ?? 0,
        );
        await sqfLiteCurd.delete(
          tableKey: TableKeys.expensesTable,
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }
    affectedCardIds.remove(0);
    return affectedCardIds;
  }

  Future<double> sumCardSpend({
    required int cardId,
    required String ownerId,
    bool isSharedWithMe = false,
  }) async {
    final myUid = FirebasePaths.currentUid ?? '';
    final expenses = await getAllExpenses(
      propertyCardId: cardId.toString(),
    );
    double total = 0;
    for (final item in expenses) {
      if (item.isDeleted == 1) continue;
      final expOwner = item.propertyOwnerId ?? '';
      if (isSharedWithMe) {
        if (expOwner != ownerId) continue;
      } else if (expOwner.isNotEmpty &&
          expOwner != ownerId &&
          expOwner != myUid) {
        continue;
      }
      total += item.amount ?? 0;
    }
    return total;
  }

  Future<double> recalculateCardSpend({
    required int cardId,
    required String ownerId,
    bool isSharedWithMe = false,
    bool markOwnedPending = true,
  }) async {
    final currentUserEmail = await getCurrentUserEmail();
    final myUid = FirebasePaths.currentUid ?? '';
    final expenses = await getAllExpenses(
      propertyCardId: cardId.toString(),
    );
    double total = 0;
    for (final item in expenses) {
      if (item.isDeleted == 1) continue;
      final expOwner = item.propertyOwnerId ?? '';
      if (isSharedWithMe) {
        if (expOwner != ownerId) continue;
      } else if (expOwner.isNotEmpty &&
          expOwner != ownerId &&
          expOwner != myUid) {
        continue;
      }
      total += item.amount ?? 0;
    }

    final properties = await propertiesLocalSource.getPropertiesList(
      currentUserEmail: currentUserEmail,
    );
    for (final element in properties) {
      if (element.cardId != cardId) continue;
      if ((element.ownerId ?? '') != ownerId) continue;
      if (element.isSharedWithMe != isSharedWithMe) continue;
      final percent = element.monthlyBudget == 0
          ? 0.0
          : (total / element.monthlyBudget) * 100;
      final spendSame =
          ((element.monthlyExpenses ?? 0) - total).abs() < 0.009 &&
          ((element.progress ?? 0) - percent).abs() < 0.009;
      if (spendSame) return total;
      await propertiesLocalSource.updateProperty(
        model: element.copyWith(
          monthlyExpenses: total,
          progress: percent,
          updateAt: DateTime.now().toString(),
          syncStatus: element.isSharedWithMe || !markOwnedPending
              ? element.syncStatus
              : SyncStatus.pending,
        ),
        currentUserEmail: currentUserEmail,
      );
      return total;
    }
    return total;
  }

  Future updateExpense({
    required ExpenseModel model,
    required String currentUserEmail,
  }) async {
    try {
      await sqfLiteCurd.update(
        tableKey: TableKeys.expensesTable,
        value: model.toMap(),
        where: 'email=? AND expenseId=? AND IFNULL(createdById, "")=?',
        whereArgs: [
          currentUserEmail,
          model.id,
          model.createdById ?? '',
        ],
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
