import 'package:expense_app/core/data_source/expense_data_source/expense_local_source.dart';
import 'package:expense_app/core/data_source/expense_data_source/expense_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:intl/intl.dart';

import '../domain/entitity/summary_entity_model.dart';
import '../domain/repos_inter/summary_repo_inter.dart';

class SummaryRepo implements SummaryRepoInter {
  ExpenseLocalSource expenseLocalSource;
  PropertiesLocalSource propertiesLocalSource;
  ExpenseRemoteSource expenseRemoteSource;

  SummaryRepo({
    required this.expenseLocalSource,
    required this.propertiesLocalSource,
    required this.expenseRemoteSource,
  });

  @override
  Future<SummaryEntityModel> getSummaryData({
    required int propertyCardId,
    String? propertyOwnerId,
    bool isSharedWithMe = false,
    double? monthlyBudget,
  }) async {
    final expenses = await _loadExpenses(
      propertyCardId: propertyCardId,
      propertyOwnerId: propertyOwnerId,
      isSharedWithMe: isSharedWithMe,
    );

    final budget =
        monthlyBudget ??
        await _getMonthlyBudget(
          propertyCardId,
          propertyOwnerId: isSharedWithMe ? propertyOwnerId : '',
        );

    List<CategoryBreakdownEntityModel> categoryBreakdown = [];
    Map<String, double> categoryTotals = {};
    Map<String, double> monthlyTotals = {};
    List<MonthlyExpense> monthlyList = [];

    Set<String> categories = {};
    double totalExpense = 0.0;

    for (var item in expenses) {
      final category = item.categoryType ?? 'Other';
      final amount = item.amount ?? 0.0;
      categories.add(category);

      totalExpense += amount;
      categoryTotals[category] = (categoryTotals[category] ?? 0.0) + amount;

      if (item.date != null) {
        final date = DateFormat("dd/MM/yyyy").parse(item.date!);
        final key = "${date.month}-${date.year}";
        monthlyTotals[key] = (monthlyTotals[key] ?? 0.0) + amount;
      }
    }

    monthlyTotals.forEach((key, value) {
      final parts = key.split('-');
      final month = int.parse(parts[0]);
      final monthName = DateFormat.MMM().format(DateTime(0, month));
      monthlyList.add(MonthlyExpense(month: monthName, amount: value));
    });

    for (var item in categories) {
      final categoryTotal = categoryTotals[item] ?? 0.0;
      final progress = budget > 0 ? (categoryTotal / budget) * 100 : 0.0;

      categoryBreakdown.add(
        CategoryBreakdownEntityModel(
          categoryName: item,
          totalAmount: categoryTotal,
          progress: progress,
        ),
      );
    }

    return SummaryEntityModel(
      totalExpense: totalExpense,
      categoryBreakdown: categoryBreakdown,
      expenses: monthlyList,
    );
  }

  Future<double> _getMonthlyBudget(
    int propertyCardId, {
    String? propertyOwnerId,
  }) async {
    final currentUserEmail = await propertiesLocalSource.getCurrentUserEmail();
    final properties = await propertiesLocalSource.getPropertiesList(
      currentUserEmail: currentUserEmail,
    );

    for (var property in properties) {
      if (property.cardId != propertyCardId) continue;
      if ((property.ownerId ?? '') != (propertyOwnerId ?? '')) continue;
      return property.monthlyBudget;
    }
    return 0.0;
  }

  @override
  Future<List<ExpenseEntity>> getAllExpenses({
    required int propertyCardId,
    String? propertyOwnerId,
    bool isSharedWithMe = false,
  }) async {
    final expenses = await _loadExpenses(
      propertyCardId: propertyCardId,
      propertyOwnerId: propertyOwnerId,
      isSharedWithMe: isSharedWithMe,
    );
    return expenses.map((items) => items.toEntity()).toList();
  }

  Future<List<ExpenseModel>> _loadExpenses({
    required int propertyCardId,
    String? propertyOwnerId,
    bool isSharedWithMe = false,
  }) async {
    final ownerKey = isSharedWithMe ? (propertyOwnerId ?? '') : '';
    final local = await expenseLocalSource.getAllExpenses(
      propertyCardId: propertyCardId.toString(),
      propertyOwnerId: ownerKey,
    );
    if (!isSharedWithMe ||
        propertyOwnerId == null ||
        propertyOwnerId.isEmpty) {
      return local;
    }
    if (!await InternetUtils.hasInternetAccess()) return local;
    try {
      final remote = await expenseRemoteSource.getAllExpenses(
        propertyCardId: propertyCardId.toString(),
        propertyOwnerUid: propertyOwnerId,
      );
      return _mergeExpenses(local, remote);
    } catch (_) {
      return local;
    }
  }

  List<ExpenseModel> _mergeExpenses(
    List<ExpenseModel> local,
    List<ExpenseModel> remote,
  ) {
    final byId = <dynamic, ExpenseModel>{};
    for (final item in remote) {
      byId[item.id] = item;
    }
    for (final item in local) {
      byId[item.id] = item;
    }
    return byId.values.toList();
  }
}
