import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';

class AddExpensesLocal {
  SqfLiteCurd sqfLiteCurd;

  AddExpensesLocal({required this.sqfLiteCurd});

  Future addNewCategory(String categoryName) async {
    await sqfLiteCurd.save(
      tableKey: TableKeys.categoryTable,
      value: {'categoryName': categoryName},
    );
  }

  Future getCategories(String categoryName) async {
    final result = await sqfLiteCurd.get(tableKey: TableKeys.categoryTable);
    if (result.isEmpty) return [];
    return result;
  }
}
