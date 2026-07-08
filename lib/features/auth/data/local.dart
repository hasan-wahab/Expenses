import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/features/auth/data/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

class AuthLocal {
  SqfLiteCurd sqfLiteCurd;

  AuthLocal({required this.sqfLiteCurd});

  Future saveUser({required UserModel model}) async {
    try {
      await deleteUser();
      await sqfLiteCurd.save(
        tableKey: TableKeys.userTable,
        value: model.toMap(),
      );
    } on Exception {
      rethrow;
    }
  }

  Future<UserModel> getUser() async {
    try {
      List<Map<String, dynamic>> result = await sqfLiteCurd.get(
        tableKey: TableKeys.userTable,
      );
      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first); // ✅ direct
      }
      throw Exception('User not found');
    } on Exception {
      rethrow;
    }
  }

  Future saveCurrentUserEmail({required String email}) async {
    try {
      await sqfLiteCurd.delete(tableKey: TableKeys.currentUserEmailTable);
      await sqfLiteCurd.save(
        tableKey: TableKeys.currentUserEmailTable,
        value: {'email': email},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on Exception {
      rethrow;
    }
  }

  Future<String> getCurrentUserEmail() async {
    try {
      List result = await sqfLiteCurd.get(
        tableKey: TableKeys.currentUserEmailTable,
      );
      if (result.isNotEmpty) {
        return result.first['email'];
      }
      throw Exception('User not found');
    } on Exception {
      rethrow;
    }
  }

  Future deleteUser() async {
    try {
      await sqfLiteCurd.delete(tableKey: TableKeys.userTable);
    } on Exception {
      rethrow;
    }
  }
}
