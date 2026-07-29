import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';

import '../../../../core/constant/enums.dart';
import '../../domain/entitity/dashboard_card_entity.dart';

abstract class DashboardStates {}

class DashboardInitial extends DashboardStates {}

class GetProperties extends DashboardStates {
  Status status;
  final List<DashboardCardEntity> propertyList;
  final String errorMessage;
  GetProperties({
    required this.propertyList,
    required this.status,
    this.errorMessage = '',
  });
}
