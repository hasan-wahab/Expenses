import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddExpensesStates {}

class AddExpensesInitial extends AddExpensesStates {}

class GetNewCategoryState extends AddExpensesStates {
  List<String>? categoryList;
  GetNewCategoryState({this.categoryList});
}

class GetSelectedCategoryState extends AddExpensesStates {
  String selectedCategory;
  GetSelectedCategoryState({this.selectedCategory = 'Other'});
}

class SaveExpensesState extends AddExpensesStates {
  Status status;
  String? message;
  SaveExpensesState({required this.status, this.message = ''});
}

class GetPropertyCardState extends AddExpensesStates {
  Status status;
  String? message;
  List<DashboardCardEntity>? propertyCardList;
  GetPropertyCardState({
    required this.status,
    this.message = '',
    this.propertyCardList,
  });
}

class PickReceiptImageState extends AddExpensesStates {
  final Status status;
  final XFile? imagePath;
  final String? message;
  PickReceiptImageState({
    required this.status,
    this.imagePath,
    this.message,
  });
}
