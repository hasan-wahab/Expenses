import '../../../../core/constant/enums.dart';
import '../../domain/entitity/dashboard_card_entity.dart';

abstract class DashboardStates {}

class DashboardInitial extends DashboardStates {}

class GetPropertyCardState extends DashboardStates {
  List<DashboardCardEntity> propertyCardList;
  Status status;

  String message;

  GetPropertyCardState({
    required this.propertyCardList,
    required this.status,
    this.message = '',
  });
}
