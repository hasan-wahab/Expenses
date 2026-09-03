import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/app_key/firebase_paths.dart';

import '../../../features/add_expenses/data/models/expense_model.dart';
import '../../constant/app_key/table_keys.dart';
import '../../storage/sqflite_curd.dart';

class ExpenseRemoteSource {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  SqfLiteCurd sqfLiteCurd;
  ExpenseRemoteSource({required this.sqfLiteCurd});

  Future<String> _currentUserEmail() async {
    return await sqfLiteCurd
        .get(tableKey: TableKeys.currentUserEmailTable)
        .then((value) => value.first['email']);
  }

  Map<String, dynamic> _expensePayload({
    required ExpenseModel model,
    required String propertyOwnerUid,
    required String createdById,
    List<String> memberIds = const [],
  }) {
    final cardId = model.propertyCardId ?? 0;
    final map = Map<String, dynamic>.from(model.toMap());
    map.remove('isSharedWithMe');
    return {
      ...map,
      'propertyId': FirebasePaths.propertyId(
        ownerUid: propertyOwnerUid,
        cardId: cardId,
      ),
      'propertyOwnerId': propertyOwnerUid,
      'ownerId': createdById,
      'createdById': createdById,
      if (memberIds.isNotEmpty) 'memberIds': memberIds,
    };
  }

  Future<List<String>> _propertyMemberIds({
    required String propertyOwnerUid,
    required int cardId,
  }) async {
    try {
      final snap = await FirebasePaths.propertyDoc(
        FirebasePaths.propertyId(
          ownerUid: propertyOwnerUid,
          cardId: cardId,
        ),
      ).get();
      final ids = snap.data()?['memberIds'];
      if (ids is List) {
        return ids
            .map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } catch (_) {}
    return const [];
  }

  Future addNewExpense({
    required ExpenseModel model,
    String? propertyOwnerUid,
  }) async {
    try {
      final currentUid = FirebasePaths.requireUid();
      final propertyOwner =
          (propertyOwnerUid != null && propertyOwnerUid.isNotEmpty)
          ? propertyOwnerUid
          : currentUid;
      final localExpenseId = model.id ?? 0;
      final memberIds = await _propertyMemberIds(
        propertyOwnerUid: propertyOwner,
        cardId: model.propertyCardId ?? 0,
      );
      await FirebasePaths.expenseDoc(
            FirebasePaths.expenseId(
              ownerUid: currentUid,
              expenseId: localExpenseId,
            ),
          )
          .set(
            _expensePayload(
              model: model,
              propertyOwnerUid: propertyOwner,
              createdById: currentUid,
              memberIds: memberIds,
            ),
            SetOptions(merge: true),
          )
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
    String? propertyOwnerUid,
  }) async {
    try {
      final currentUid = FirebasePaths.requireUid();
      final ownerUid =
          (propertyOwnerUid != null && propertyOwnerUid.isNotEmpty)
          ? propertyOwnerUid
          : currentUid;
      final cardId = int.tryParse(propertyCardId) ?? 0;
      final propertyId = FirebasePaths.propertyId(
        ownerUid: ownerUid,
        cardId: cardId,
      );
      final result = await FirebasePaths.expensesCol
          .where('propertyId', isEqualTo: propertyId)
          .get();
      if (result.docs.isNotEmpty) {
        return result.docs
            .map((e) => ExpenseModel.fromMap(e.data()))
            .toList();
      }

      if (ownerUid != currentUid) return [];

      return await _migrateLegacyExpenses(
        propertyCardId: propertyCardId,
        ownerUid: ownerUid,
        cardId: cardId,
      );
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

  Future<List<ExpenseModel>> _migrateLegacyExpenses({
    required String propertyCardId,
    required String ownerUid,
    required int cardId,
  }) async {
    final currentUserEmail = await _currentUserEmail();
    final legacy = await FirebasePaths.legacyExpensesCol(
      email: currentUserEmail,
      cardId: propertyCardId,
    ).get();
    if (legacy.docs.isEmpty) return [];

    final list = <ExpenseModel>[];
    for (final doc in legacy.docs) {
      final model = ExpenseModel.fromMap(doc.data());
      list.add(model);
      final localExpenseId = model.id ?? 0;
      await FirebasePaths.expenseDoc(
        FirebasePaths.expenseId(ownerUid: ownerUid, expenseId: localExpenseId),
      ).set(
        _expensePayload(
          model: model,
          propertyOwnerUid: ownerUid,
          createdById: ownerUid,
        ),
        SetOptions(merge: true),
      );
    }
    return list;
  }

  Future updateExpense({required ExpenseModel model}) async {
    try {
      final ownerUid = FirebasePaths.requireUid();
      final localExpenseId = model.id ?? 0;
      await FirebasePaths.expenseDoc(
        FirebasePaths.expenseId(ownerUid: ownerUid, expenseId: localExpenseId),
      ).set(
        _expensePayload(
          model: model,
          propertyOwnerUid: ownerUid,
          createdById: ownerUid,
        ),
        SetOptions(merge: true),
      );
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
