import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:sqflite/sqflite.dart';

import '../../../features/dashboard/data/models/property_card_model.dart';

class PropertiesLocalSource {
  SqfLiteCurd sqfLiteCurd;
  PropertiesLocalSource({required this.sqfLiteCurd});

  String _ownerKey(PropertyModel model) => model.ownerId ?? '';

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

  Future upsertProperty({
    required PropertyModel model,
    required String currentUserEmail,
  }) async {
    try {
      await sqfLiteCurd.save(
        tableKey: TableKeys.propertyCardTable,
        value: {'email': currentUserEmail, ...model.toMap()},
        conflictAlgorithm: ConflictAlgorithm.replace,
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

  Future<void> applySharedCards({
    required String currentUserEmail,
    required List<PropertyModel> remoteShared,
  }) async {
    final localList = await getPropertiesList(
      currentUserEmail: currentUserEmail,
    );
    final localShared = localList.where((e) => e.isSharedWithMe).toList();

    for (final local in localShared) {
      final stillShared = remoteShared.any(
        (remote) =>
            remote.ownerId == local.ownerId && remote.cardId == local.cardId,
      );
      if (!stillShared) {
        await deleteProperty(
          cardId: local.cardId,
          currentUserEmail: currentUserEmail,
          ownerId: local.ownerId,
          deleteLocalExpenses: true,
        );
      }
    }

    for (final remote in remoteShared) {
      final existing = localList.where(
        (local) =>
            local.isSharedWithMe &&
            local.ownerId == remote.ownerId &&
            local.cardId == remote.cardId,
      );
      final localCard = existing.isEmpty ? null : existing.first;
      if (localCard != null && _sameSharedCard(localCard, remote)) {
        continue;
      }
      await upsertProperty(
        model: remote.copyWith(
          syncStatus: SyncStatus.synced,
          monthlyExpenses:
              localCard?.monthlyExpenses ?? remote.monthlyExpenses,
          progress: localCard?.progress ?? remote.progress,
          updateAt: localCard?.updateAt ?? remote.updateAt,
        ),
        currentUserEmail: currentUserEmail,
      );
    }
  }

  bool _sameSharedCard(PropertyModel local, PropertyModel remote) {
    bool sameNum(num? a, num? b) => ((a ?? 0) - (b ?? 0)).abs() < 0.009;
    if (local.propertyName != remote.propertyName) return false;
    if (local.propertyLocation != remote.propertyLocation) return false;
    if (local.imageUrl != remote.imageUrl) return false;
    if (local.categoryType != remote.categoryType) return false;
    if (!sameNum(local.monthlyBudget, remote.monthlyBudget)) return false;
    if (local.myPermissions.join(',') != remote.myPermissions.join(',')) {
      return false;
    }
    return true;
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
          ...model.toMap(),
        },
        where: 'email = ? AND cardId = ? AND IFNULL(ownerId, "") = ?',
        whereArgs: [currentUserEmail, model.cardId, _ownerKey(model)],
      );
    } on Exception {
      rethrow;
    }
  }

  Future deleteProperty({
    required int cardId,
    required String currentUserEmail,
    String? ownerId,
    bool deleteLocalExpenses = true,
  }) async {
    try {
      await sqfLiteCurd.delete(
        tableKey: TableKeys.propertyCardTable,
            where: 'email = ? AND cardId = ? AND IFNULL(ownerId, "") = ?',
        whereArgs: [currentUserEmail, cardId, ownerId ?? ''],
      );

      if (deleteLocalExpenses) {
        await sqfLiteCurd.delete(
          tableKey: TableKeys.expensesTable,
          where:
              'email = ? AND propertyCardId = ? AND IFNULL(propertyOwnerId, "") = ?',
          whereArgs: [currentUserEmail, cardId, ownerId ?? ''],
        );
      }
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
