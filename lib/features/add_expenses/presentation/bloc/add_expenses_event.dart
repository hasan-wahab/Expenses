abstract class AddExpensesEvent {}

class AddNewCategoryEvent extends AddExpensesEvent {
  final String categoryName;
  AddNewCategoryEvent({required this.categoryName});
}
