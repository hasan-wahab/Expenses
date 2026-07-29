import 'package:expense_app/core/constant/enums.dart';

import '../../../add_expenses/domain/entitity/add_expense_entity_model.dart';
import '../../domain/entitity/summary_entity_model.dart';

class SummaryStates {}

class SummaryInitialState extends SummaryStates {}

class GetSummaryDataState extends SummaryStates {
  final SummaryEntityModel? summaryEntityModel;
  List<ExpenseEntity>? expenses;
  final Status status;
  final String? message;
  GetSummaryDataState({
    this.summaryEntityModel,
    this.expenses,
    required this.status,
    this.message = '',
  });
}
