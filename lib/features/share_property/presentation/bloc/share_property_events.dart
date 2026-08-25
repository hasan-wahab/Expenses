import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';

abstract class SharePropertyEvents {}

class LoadShareMembersEvent extends SharePropertyEvents {
  final DashboardCardEntity card;
  LoadShareMembersEvent({required this.card});
}

class ShareEmailChangedEvent extends SharePropertyEvents {
  final String email;
  ShareEmailChangedEvent({required this.email});
}

class ToggleSharePermissionEvent extends SharePropertyEvents {
  final String permissionId;
  ToggleSharePermissionEvent({required this.permissionId});
}

class SubmitSharePropertyEvent extends SharePropertyEvents {
  final String email;
  SubmitSharePropertyEvent({this.email = ''});
}

class RemoveShareMemberEvent extends SharePropertyEvents {
  final String email;
  final String? uid;
  RemoveShareMemberEvent({required this.email, this.uid});
}
