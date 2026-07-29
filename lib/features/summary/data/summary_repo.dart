import 'dart:math';

import 'package:expense_app/core/data_source/expense_data_source/expense_local_source.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/entitity/summary_entity_model.dart';
import '../domain/repos_inter/summary_repo_inter.dart';

class SummaryRepo implements SummaryRepoInter {
  ExpenseLocalSource expenseLocalSource;
  SummaryRepo({required this.expenseLocalSource});
  @override
  Future<SummaryEntityModel> getSummaryData({
    required int propertyCardId,
  }) async {
    List<ExpenseModel> expenses = await expenseLocalSource.getAllExpenses(
      propertyCardId: propertyCardId.toString(),
    );
    List<CategoryBreakdownEntityModel> categoryBreakdown = [];
    Map<String, double> categoryTotals = {};
    Map<String, double> categoryProgress = {};
    Map<String, double> monthlyTotals = {};
    List<MonthlyExpense> monthlyList = [];

    Set<String> categories = {};
    double totalExpense = 0.0;

    for (var item in expenses) {
      final category = item.categoryType ?? 'Other';
      final amount = item.amount ?? 0.0;
      categories.add(category);

      // total expense
      totalExpense += amount;
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
        categoryProgress[category] =
            (categoryTotals[category]! / totalExpense) * 100;
      } else {
        categoryTotals[category] = amount;
        categoryProgress[category] = (amount / totalExpense) * 100;
      }
      if (item.date != null) {
        final date = DateFormat("dd/MM/yyyy").parse(item.date!);

        final key = "${date.month}-${date.year}"; // e.g: 7-2026

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
      categoryBreakdown.add(
        CategoryBreakdownEntityModel(
          categoryName: item,
          totalAmount: categoryTotals[item] ?? 0.0,
          progress: categoryProgress[item] ?? 0.0,
        ),
      );
    }
    return SummaryEntityModel(
      totalExpense: totalExpense,
      categoryBreakdown: categoryBreakdown,
      expenses: monthlyList,
    );
  }

  @override
  Future<List<ExpenseEntity>> getAllExpenses({
    required int propertyCardId,
  }) async {
    List<ExpenseModel> expenses = await expenseLocalSource.getAllExpenses(
      propertyCardId: propertyCardId.toString(),
    );
    List<ExpenseEntity> expenseEntity = [];
    for (var items in expenses) {
      expenseEntity.add(items.toEntity());
    }
    return expenseEntity;
  }
}
