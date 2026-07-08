import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite.dart';
import 'package:sqflite/sqflite.dart';

class SqfLiteCurd {
  final DBHelper dB;

  SqfLiteCurd({required this.dB});

  /// Save Data In Local Storage
  Future save({
    required String tableKey,
    required Map<String, dynamic> value,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    try {
      final db = await dB.database;
      await db.insert(tableKey, value, conflictAlgorithm: conflictAlgorithm);
    } on Exception {
      rethrow;
    }
  }

  /// Get Data From Local Storage
  Future<List<Map<String, dynamic>>> get({
    required String tableKey,
    int? limit,
    String? where,
    List<String>? whereArgs,
  }) async {
    try {
      final db = await dB.database;
      final result = await db.query(
        tableKey,
        limit: limit,
        where: where,
        whereArgs: whereArgs,
      );
      return result;
    } on Exception {
      rethrow;
    }
  }

  /// Delete Data From Local Storage
  Future delete({required String tableKey}) async {
    try {
      final db = await dB.database;
      db.delete(tableKey);
    } on Exception {
      rethrow;
    }
  }
}
