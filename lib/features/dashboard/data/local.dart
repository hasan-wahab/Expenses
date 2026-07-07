import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/dashboard/data/models/dashboard_card_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';

class DashboardLocal {
  final SqfLiteCurd sqfLiteCurd;

  DashboardLocal({required this.sqfLiteCurd});

  /// Save New Property in Local
  Future addNewPropertyCard({required DashboardCardModel model}) async {
    try {
      await sqfLiteCurd.save(
        tableKey: TableKeys.propertyCardTable,
        value: model.toMap(),
      );
    } on Exception {
      rethrow;
    }
  }

  /// Get Property Card List From Local
  Future<List<DashboardCardModel>> getPropertyList() async {
    List<DashboardCardModel> list = [];
    try {
      List<Map<String, dynamic>> result = await sqfLiteCurd.get(
        tableKey: TableKeys.propertyCardTable,
      );
      list = result.map((e) => DashboardCardModel.fromMap(e)).toList();
      return list;
    } on Exception {
      rethrow;
    }
  }

  /// Delete
  Future delete() async {
    try {
      await sqfLiteCurd.delete(tableKey: TableKeys.propertyCardTable);
    } on Exception {
      rethrow;
    }
  }

  /// Update Property by Id
  Future updatePropertyByID({required String dashboardCardId}) async {}
}
