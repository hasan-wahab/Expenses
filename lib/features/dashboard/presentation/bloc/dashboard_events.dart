import 'package:expense_app/features/add_expenses/domain/entitity/add_expense_entity_model.dart';

import '../../domain/entitity/dashboard_card_entity.dart';

abstract class DashboardEvents {}

class AddPropertyEvent extends DashboardEvents {
  final DashboardCardEntity entity;
  AddPropertyEvent({required this.entity});
}

class GetPropertiesEvent extends DashboardEvents {}

class DeletePropertyEvent extends DashboardEvents {
  final DashboardCardEntity propertyEntity;
  DeletePropertyEvent({required this.propertyEntity,});
}

class SyncPropertiesNewAndDeletedEvent extends DashboardEvents {}

class UpdatePropertiesSyncEvent extends DashboardEvents {}
