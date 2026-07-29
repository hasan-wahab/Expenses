import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../../features/add_expenses/data/models/expense_model.dart';

class ExportPdfUtils {
  List<ExpenseModel> filterExpenses({
    required List<ExpenseModel> expenses,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final formatter = DateFormat('dd/MM/yyyy');

    final filteredExpenses = expenses.where((expense) {
      DateTime date = formatter.parse(expense.date.toString());

      return !date.isBefore(startDate) && !date.isAfter(endDate);
    }).toList();

    return List<ExpenseModel>.from(filteredExpenses.map((e) => e));
  }
}
