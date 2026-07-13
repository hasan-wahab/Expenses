import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:sqflite/sqflite.dart';

import '../../../features/dashboard/data/models/property_card_model.dart';

class PropertiesLocalSource {
  SqfLiteCurd sqfLiteCurd;
  PropertiesLocalSource({required this.sqfLiteCurd});
  Future addNewProperty({
    required PropertyModel model,
    required String currentUserEmail,
  }) async {
    try {
      await sqfLiteCurd.save(
        tableKey: TableKeys.propertyCardTable,
        value: {'email': currentUserEmail, ...model.toMap()},
      );
    } on Exception {
      rethrow;
    }
  }

  Future<List<PropertyModel>> getPropertiesList({
    required String currentUserEmail,
  }) async {
    List<PropertyModel> list = [];
    try {
      final result = await sqfLiteCurd.get(
        tableKey: TableKeys.propertyCardTable,
        where: 'email = ?',
        whereArgs: [currentUserEmail],
      );
      if (result.isEmpty) return [];
      for (var element in result) {
        list.add(PropertyModel.fromMap(element));
      }
      return list;
    } on Exception {
      rethrow;
    }
  }

  Future updateProperty({
    required PropertyModel model,
    required String currentUserEmail,
  }) async {
    try {
      await sqfLiteCurd.update(
        tableKey: TableKeys.propertyCardTable,
        value: {
          'email': currentUserEmail,
          'cardId': model.cardId,
          ...model.toMap(),
        },
        where: 'email = ? AND cardId = ?',
        whereArgs: [currentUserEmail, model.cardId],
      );
    } on Exception {
      rethrow;
    }
  }

  Future deleteProperty({
    required int cardId,
    required String currentUserEmail,
  }) async {
    try {
      await sqfLiteCurd.delete(
        tableKey: TableKeys.propertyCardTable,
        where: 'email = ? AND cardId = ?',
        whereArgs: [currentUserEmail, cardId],
      );
    } on Exception {
      rethrow;
    }
  }

  Future<String> getCurrentUserEmail() async {
    final result = await sqfLiteCurd.get(
      tableKey: TableKeys.currentUserEmailTable,
    );
    if (result.isNotEmpty) {
      return result.first['email'];
    } else {
      throw 'Email not found';
    }
  }

  Future addNewCategory({required String categoryName}) async {
    try {
      await sqfLiteCurd.save(
        tableKey: TableKeys.categoryTable,
        value: {'email': categoryName},
      );
    } on Exception {
      rethrow;
    }
  }

  Future<List<String>> getCategoryList() async {
    try {
      final result = await sqfLiteCurd.get(tableKey: TableKeys.categoryTable);
      return result.map((e) => e['categoryName'].toString()).toList();
    } on Exception {
      rethrow;
    }
  }
}
