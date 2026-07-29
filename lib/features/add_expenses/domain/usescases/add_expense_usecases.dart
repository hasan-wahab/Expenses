import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/features/add_expenses/data/expenses_repo.dart';
import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';

import '../../data/models/expense_model.dart';

class AddExpenseUseCases {
  ExpensesRepo expensesRepo;
  AddExpenseUseCases({required this.expensesRepo});

  Future addCategoryCall({required String categoryName}) async {
    await expensesRepo.addNewCategory(categoryName);
  }

  Future<List<String>> getCategoriesCall() async {
    List<String> categories = [];
    categories = await expensesRepo.getCategories();
    return categories;
  }

  Future addNewExpenseCall({required ExpenseEntity entityModel}) async {
    await expensesRepo.addNewExpense(
      model: ExpenseModel.fromEntity(entityModel),
    );
  }

  Future<List<DashboardCardEntity>> getPropertyCardCall() async {
    return await expensesRepo.getPropertyCard();
  }
}
