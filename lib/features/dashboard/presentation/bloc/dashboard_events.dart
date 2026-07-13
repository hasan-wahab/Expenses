import '../../domain/entitity/dashboard_card_entity.dart';

abstract class DashboardEvents {}

class AddPropertyEvent extends DashboardEvents {
  final DashboardCardEntity entity;
  AddPropertyEvent({required this.entity});
}

class GetPropertiesEvent extends DashboardEvents {}

class DeletePropertyEvent extends DashboardEvents {
  final DashboardCardEntity entity;
  DeletePropertyEvent({required this.entity});
}

class UpdatePropertyEvent extends DashboardEvents {
  final DashboardCardEntity entity;
  UpdatePropertyEvent({required this.entity});
}

class SyncPropertiesNewAndDeletedEvent extends DashboardEvents {}

class UpdatePropertiesSyncEvent extends DashboardEvents {}
