abstract class AddExpensesStates {}


class AddExpensesInitial extends AddExpensesStates {}
class GetNewCategoryState extends AddExpensesStates {
  String? categoryName;
  GetNewCategoryState({this.categoryName});
}
