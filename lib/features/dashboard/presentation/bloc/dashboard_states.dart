import '../../../../core/constant/enums.dart';
import '../../domain/entitity/dashboard_card_entity.dart';

abstract class DashboardStates {}

class DashboardInitial extends DashboardStates {}

class GetProperties extends DashboardStates {
  Status status;
  final List<DashboardCardEntity> list;
  final String errorMessage;
  GetProperties({
    required this.list,
    required this.status,
    this.errorMessage = '',
  });
}
