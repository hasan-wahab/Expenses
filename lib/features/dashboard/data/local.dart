import 'dart:convert';

import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/auth/data/local.dart';
import 'package:expense_app/features/dashboard/data/models/dashboard_card_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:sqflite/sqflite.dart';

class DashboardLocal {
  final SqfLiteCurd sqfLiteCurd;
  final AuthLocal local;
  DashboardLocal({required this.sqfLiteCurd, required this.local});

  /// Save New Property in Local
  Future addNewPropertyCard({required DashboardCardModel model}) async {
    try {
      /// Get Current User Email
      String currentUserEmail = await local.getCurrentUserEmail();

      /// Save Property in Local
      /// Save Property with Current User Email
      await sqfLiteCurd.save(
        tableKey: TableKeys.propertyCardTable,
        value: {'email': currentUserEmail, ...model.toMap()},
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get Property Card List From Local
  Future<List<DashboardCardModel>> getPropertyList() async {
    List<DashboardCardModel> list = [];
    try {
      /// Get Current User Email
      String currentUserEmail = await local.getCurrentUserEmail();

      /// Get Property List From Local
      /// Get Property List with Current User Email
      final result = await sqfLiteCurd.get(
        tableKey: TableKeys.propertyCardTable,
        where: 'email = ?',
        whereArgs: [currentUserEmail],
      );
      return result.map((e) => DashboardCardModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Delete
  Future deleteAllTable() async {
    try {
      /// Delete Property From Local
      await sqfLiteCurd.delete(tableKey: TableKeys.propertyCardTable);
    } on Exception {
      rethrow;
    }
  }

  /// Update Property by Id
  Future updatePropertyByID({
    required String currentUserEmail,
    required String dashboardCardId,
  }) async {
    await sqfLiteCurd.delete(
      tableKey: TableKeys.propertyCardTable,
      where: 'email = ? AND cardId = ?',
      whereArgs: [currentUserEmail, dashboardCardId],
    );
  }
}
