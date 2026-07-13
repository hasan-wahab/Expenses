import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';

import 'enums.dart';

class AppPropertyArgs {
  final DashboardCardEntity? cardEntity;
  final AddPropertyMode mode;
  AppPropertyArgs({ this.cardEntity, this.mode = AddPropertyMode.add});
}
