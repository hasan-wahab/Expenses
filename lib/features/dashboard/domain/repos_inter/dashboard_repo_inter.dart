import 'package:expense_app/features/dashboard/data/models/dashboard_card_model.dart';

abstract class DashboardRepoInter {
  /// Save
  Future save({required DashboardCardModel model});

  /// Get
  Future<List<DashboardCardModel>> get();

  /// Update
  Future update({required DashboardCardModel model});

  /// Delete
  Future delete({required String dashboardCardId});
}
