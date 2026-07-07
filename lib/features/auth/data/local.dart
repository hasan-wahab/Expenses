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
      List result = await sqfLiteCurd.get(
        tableKey: TableKeys.userTable,
        limit: 1,
      );

      if (result.isNotEmpty) {
        final user = UserModel.fromMap(result.last);

        return user;
      }

      throw Exception('User not fount');
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
