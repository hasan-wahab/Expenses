import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';

class SummaryEntityModel {
  final double totalExpense;

  List<CategoryBreakdownEntityModel> categoryBreakdown = [];
  List<MonthlyExpense> expenses = [];
  SummaryEntityModel({
    required this.totalExpense,
    required this.categoryBreakdown,
    required this.expenses,
  });
}

class CategoryBreakdownEntityModel {
  final String categoryName;
  final double totalAmount;
  final double progress;
  CategoryBreakdownEntityModel({
    required this.categoryName,
    required this.totalAmount,
    required this.progress,
  });
}

class MonthlyExpense {
  final String month;
  final double amount;
  MonthlyExpense({required this.month, required this.amount});
}
