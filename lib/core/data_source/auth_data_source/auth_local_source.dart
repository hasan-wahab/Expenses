import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:sqflite/sqflite.dart';

import '../../../features/auth/data/models/auth_model.dart';

class AuthLocalSource {
  SqfLiteCurd sqfLiteCurd;
  AuthLocalSource({required this.sqfLiteCurd});
  Future save({required UserModel model}) async {
    try {
      await sqfLiteCurd.save(
        tableKey: TableKeys.userTable,
        value: model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> get({required String email}) async {
    try {
      UserModel model;
      final result = await sqfLiteCurd.get(tableKey: TableKeys.userTable);
      if (result.isEmpty) throw 'No data found';
      print(result);
      model = UserModel.fromMap(result.first);
      return model;
    } on Exception {
      rethrow;
    }
  }

  Future update({required UserModel model}) async {
    try {
      await sqfLiteCurd.update(
        tableKey: TableKeys.userTable,
        value: model.toMap(),
        where: 'email = ?',
        whereArgs: [model.email],
      );
    } on Exception {
      rethrow;
    }
  }

  Future delete() async {
    try {
      await sqfLiteCurd.delete(tableKey: TableKeys.currentUserEmailTable);
    } on Exception {
      rethrow;
    }
  }

  Future<String?> getCurrentUserEmailOrNull() async {
    try {
      final result = await sqfLiteCurd.get(
        tableKey: TableKeys.currentUserEmailTable,
      );
      if (result.isEmpty) return null;
      final email = result.first['email'];
      if (email == null || email.toString().isEmpty) return null;
      return email.toString();
    } on Exception {
      return null;
    }
  }

  Future saveCurrentUserEmail({required String email}) async {
    try {
      await sqfLiteCurd.save(
        tableKey: TableKeys.currentUserEmailTable,
        value: {'id': 1, 'email': email},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception {
      rethrow;
    }
  }

  Future getCurrentUserEmail() async {
    try {
      final result = await sqfLiteCurd.get(
        tableKey: TableKeys.currentUserEmailTable,
      );
      if (result.isEmpty) throw 'No data found';
      print(result);
      return result.first['email'];
    } on Exception {
      rethrow;
    }
  }

  Future<bool> getFingerPrint() async {
    List<Map<String, dynamic>> result = await sqfLiteCurd.get(
      tableKey: TableKeys.fingerPrintTable,
    );

    if (result.isEmpty) return false;
    final value = result.first['finger_print'];

    if (value == 1) {
      return true;
    } else {
      return false;
    }
  }
}
