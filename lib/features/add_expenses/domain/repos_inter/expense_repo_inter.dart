import 'package:expense_app/features/dashboard/data/models/property_card_model.dart';

import '../../data/models/expense_model.dart';

abstract class ExpenseRepoInter {
  Future addNewCategory(String categoryName);
  Future getCategories();
  Future addNewExpense({required ExpenseModel model});
  Future getPropertyCard();
}
