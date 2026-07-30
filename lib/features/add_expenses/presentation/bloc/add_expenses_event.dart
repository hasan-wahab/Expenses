import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddExpensesEvent {}

class SaveExpensesEvent extends AddExpensesEvent {
  ExpenseEntity expenseEntity;
  SaveExpensesEvent({required this.expenseEntity});
}

class AddNewCategoryEvent extends AddExpensesEvent {
  final String categoryName;
  AddNewCategoryEvent({required this.categoryName});
}

class SelectCategoryEvent extends AddExpensesEvent {
  final String categoryName;
  SelectCategoryEvent({required this.categoryName});
}

class OnPickReceiptImageEvent extends AddExpensesEvent {
  final ImageSource imageSource;
  OnPickReceiptImageEvent({required this.imageSource});
}

class GetNewCategoryEvent extends AddExpensesEvent {}

class GetPropertyCardEvent extends AddExpensesEvent {}
