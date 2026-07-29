import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/add_expenses/data/models/expense_model.dart';
import '../../constant/app_key/table_keys.dart';
import '../../storage/sqflite_curd.dart';

class ExpenseRemoteSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SqfLiteCurd sqfLiteCurd;
  ExpenseRemoteSource({required this.sqfLiteCurd});
  Future addNewExpense({required ExpenseModel model}) async {
    try {
      String currentUserEmail = await sqfLiteCurd
          .get(tableKey: TableKeys.currentUserEmailTable)
          .then((value) => value.first['email']);
      await firestore
          .collection('Property')
          .doc(currentUserEmail)
          .collection('PropertyList')
          .doc(model.propertyCardId.toString())
          .collection('Expenses')
          .doc(model.id.toString())
          .set(model.toMap())
          .timeout(Duration(seconds: 15));
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'resource-exhausted':
          throw "Quta pora hogya";

        case 'unavailable':
          throw Exception("No internet connection");

        case 'permission-denied':
          throw Exception("Access denied");

        default:
          throw Exception(e.message ?? "Unknown error");
      }
    } on TimeoutException {
      throw 'Something went wrong, please try again later.';
    } on Exception {
      rethrow;
    }
  }

  Future<List<ExpenseModel>> getAllExpenses({
    required String propertyCardId,
  }) async {
    try {
      String currentUserEmail = await sqfLiteCurd
          .get(tableKey: TableKeys.currentUserEmailTable)
          .then((value) => value.first['email']);
      final result = await firestore
          .collection('Property')
          .doc(currentUserEmail)
          .collection('PropertyList')
          .doc(propertyCardId)
          .collection('Expenses')
          .get();
      if (result.docs.isEmpty) return [];
      return result.docs.map((e) => ExpenseModel.fromMap(e.data())).toList();
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'resource-exhausted':
          throw "Quta pora hogya";

        case 'unavailable':
          throw Exception("No internet connection");

        case 'permission-denied':
          throw Exception("Access denied");

        default:
          throw Exception(e.message ?? "Unknown error");
      }
    } on TimeoutException {
      throw 'Something went wrong, please try again later.';
    } on Exception {
      rethrow;
    }
  }

  Future updateExpense({required ExpenseModel model}) async {
    try {
      String currentUserEmail = await sqfLiteCurd
          .get(tableKey: TableKeys.currentUserEmailTable)
          .then((value) => value.first['email']);
      await firestore
          .collection('Property')
          .doc(currentUserEmail)
          .collection('PropertyList')
          .doc(model.propertyCardId.toString())
          .collection('Expenses')
          .doc(model.id.toString())
          .update(model.toMap());
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'resource-exhausted':
          throw "Quta pora hogya";

        case 'unavailable':
          throw Exception("No internet connection");

        case 'permission-denied':
          throw Exception("Access denied");

        default:
          throw Exception(e.message ?? "Unknown error");
      }
    } on TimeoutException {
      throw 'Something went wrong, please try again later.';
    } on Exception {
      rethrow;
    }
  }
}
