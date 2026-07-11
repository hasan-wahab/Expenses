import 'package:expense_app/features/add_expenses/data/local.dart';

class AddExpenseUseCases {
  AddExpensesLocal addExpensesLocal;
  AddExpenseUseCases({required this.addExpensesLocal});


  Future addCategoryCall({required String categoryName})async{
    await addExpensesLocal.addNewCategory(categoryName);
  }
  Future<List<String>> getCategoriesCall({required String categoryName})async{
    List<String> categories = [];
   categories= await addExpensesLocal.getCategories(categoryName);
   return categories;
  }
}

