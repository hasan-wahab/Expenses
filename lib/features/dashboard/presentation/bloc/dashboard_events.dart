import '../../domain/entitity/dashboard_card_entity.dart';

abstract class DashboardEvents {}

class AddNewPropertyCardEvent extends DashboardEvents {
  DashboardCardEntity model;

  AddNewPropertyCardEvent({required this.model});
}

class GetCardListEvent extends DashboardEvents {}


class RefreshPropertyListEvent extends DashboardEvents {}
