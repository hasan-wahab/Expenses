import 'package:expense_app/core/constant/app_key/firebase_paths.dart';
import 'package:expense_app/core/data_source/expense_data_source/expense_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/utils/internet_utils.dart';

import '../../../core/constant/enums.dart';
import '../../../core/data_source/expense_data_source/expense_local_source.dart';
import '../../dashboard/data/models/property_card_model.dart';

class SyncRepo {
  final PropertiesRemoteSource remoteSource;
  final PropertiesLocalSource localSource;
  final ExpenseRemoteSource expenseRemoteSource;
  final ExpenseLocalSource expenseLocalSource;

  SyncRepo({
    required this.remoteSource,
    required this.localSource,
    required this.expenseRemoteSource,
    required this.expenseLocalSource,
  });

  Future<bool> syncAll() async {
    if (!await InternetUtils.hasInternetAccess()) return false;
    final before = await _fingerprint();
    await syncPropertiesData();
    await syncExpensesData();
    final after = await _fingerprint();
    return before != after;
  }

  Future<String> _fingerprint() async {
    final email = await localSource.getCurrentUserEmail();
    final cards = await localSource.getPropertiesList(
      currentUserEmail: email,
    );
    final expenses = await expenseLocalSource.getAllExpenses();
    final cardPart = cards
        .where((e) => !e.isDeleted)
        .map(
          (e) =>
              '${e.ownerId}_${e.cardId}:${e.monthlyExpenses}:${e.propertyName}:${e.isSharedWithMe}',
        )
        .join('|');
    final liveExpenses = expenses.where((e) => e.isDeleted != 1).length;
    return '$cardPart#$liveExpenses';
  }

  Future<void> syncPropertiesData() async {
    if (!await InternetUtils.hasInternetAccess()) return;

    try {
      final currentUserEmail = await localSource.getCurrentUserEmail();
      final list = await localSource.getPropertiesList(
        currentUserEmail: currentUserEmail,
      );

      for (final item in list) {
        try {
          if (item.isSharedWithMe) {
            if (item.syncStatus == SyncStatus.pending && !item.isDeleted) {
              await remoteSource.updatePropertyById(
                model: item,
                currentUserEmail: currentUserEmail,
                ownerUid: item.ownerId,
              );
              await localSource.updateProperty(
                model: item.copyWith(syncStatus: SyncStatus.synced),
                currentUserEmail: currentUserEmail,
              );
            }
            continue;
          }
          if (item.isDeleted == true) {
            await remoteSource.deletePropertyById(
              cardId: item.cardId,
              currentUserEmail: currentUserEmail,
            );
            await localSource.deleteProperty(
              cardId: item.cardId,
              currentUserEmail: currentUserEmail,
            );
          } else if (item.syncStatus == SyncStatus.pending) {
            await remoteSource.addNewProperty(
              model: item,
              currentUserEmail: currentUserEmail,
            );
            await localSource.updateProperty(
              model: item.copyWith(syncStatus: SyncStatus.synced),
              currentUserEmail: currentUserEmail,
            );
          }
        } catch (_) {}
      }

      await _pullOwnedMetadata(currentUserEmail);
      await _upsertSharedCards(currentUserEmail);
    } catch (_) {}
  }

  Future<void> _pullOwnedMetadata(String currentUserEmail) async {
    try {
      final remoteList = await remoteSource.getPropertiesList(
        currentUserEmail: currentUserEmail,
      );
      final localList = await localSource.getPropertiesList(
        currentUserEmail: currentUserEmail,
      );

      for (final remoteCard in remoteList) {
        final matches = localList.where(
          (e) => !e.isSharedWithMe && e.cardId == remoteCard.cardId,
        );
        if (matches.isEmpty) {
          await localSource.addNewProperty(
            model: PropertyModel.fromEntity(
              remoteCard.copyWith(syncStatus: SyncStatus.synced),
            ),
            currentUserEmail: currentUserEmail,
          );
          continue;
        }
        final localCard = matches.first;
        if (localCard.isDeleted) continue;
        if (localCard.syncStatus == SyncStatus.pending) continue;
        if (_sameOwnedMeta(localCard, remoteCard)) continue;
        await localSource.updateProperty(
          model: localCard.copyWith(
            propertyName: remoteCard.propertyName,
            propertyLocation: remoteCard.propertyLocation,
            imageUrl: remoteCard.imageUrl,
            monthlyBudget: remoteCard.monthlyBudget,
            categoryType: remoteCard.categoryType,
            ownerId: remoteCard.ownerId ?? localCard.ownerId,
            ownerEmail: remoteCard.ownerEmail ?? localCard.ownerEmail,
            syncStatus: SyncStatus.synced,
          ),
          currentUserEmail: currentUserEmail,
        );
      }
    } catch (_) {}
  }

  Future<void> _upsertSharedCards(String currentUserEmail) async {
    try {
      final remoteShared = await remoteSource.getSharedWithMe();
      await localSource.applySharedCards(
        currentUserEmail: currentUserEmail,
        remoteShared: remoteShared,
      );
    } catch (_) {}
  }

  Future<void> syncExpensesData() async {
    if (!await InternetUtils.hasInternetAccess()) return;
    try {
      final currentUserEmail = await localSource.getCurrentUserEmail();
      await expenseLocalSource.removeDuplicateExpenses();
      final touched = <String>{};

      final expensesList = await expenseLocalSource.getAllExpenses();
      for (final item in expensesList) {
        if (item.syncStatus != SyncStatus.pending.toString()) continue;
        try {
          if (item.isSharedWithMe) {
            final allowed = await remoteSource.canMemberAddExpense(
              ownerUid: item.propertyOwnerId ?? '',
              cardId: item.propertyCardId ?? 0,
            );
            if (!allowed) continue;
            await expenseRemoteSource.addNewExpense(
              model: item.copyWith(syncStatus: SyncStatus.synced.toString()),
              propertyOwnerUid: item.propertyOwnerId,
            );
          } else {
            await expenseRemoteSource.addNewExpense(
              model: item.copyWith(syncStatus: SyncStatus.synced.toString()),
            );
          }
          await expenseLocalSource.updateExpense(
            model: item.copyWith(syncStatus: SyncStatus.synced.toString()),
            currentUserEmail: currentUserEmail,
          );
          touched.add(_cardKey(item.propertyCardId ?? 0, item.propertyOwnerId));
        } catch (_) {}
      }

      final properties = (await localSource.getPropertiesList(
        currentUserEmail: currentUserEmail,
      )).where((e) => !e.isDeleted);

      for (final property in properties) {
        try {
          final remote = await expenseRemoteSource.getAllExpenses(
            propertyCardId: property.cardId.toString(),
            propertyOwnerUid: property.isSharedWithMe ? property.ownerId : null,
          );
          var expenseChanged = false;
          for (final item in remote) {
            final changed = await expenseLocalSource.upsertExpense(
              model: item.copyWith(
                propertyOwnerId: property.isSharedWithMe
                    ? (property.ownerId ?? '')
                    : (item.propertyOwnerId ?? ''),
                isSharedWithMe: property.isSharedWithMe,
                syncStatus: SyncStatus.synced.toString(),
              ),
            );
            if (changed) expenseChanged = true;
          }
          if (!expenseChanged &&
              !touched.contains(_cardKey(property.cardId, property.ownerId))) {
            continue;
          }
          final beforeSpend = property.monthlyExpenses ?? 0;
          final beforeProgress = property.progress ?? 0;
          await expenseLocalSource.recalculateCardSpend(
            cardId: property.cardId,
            ownerId: property.ownerId ?? '',
            isSharedWithMe: property.isSharedWithMe,
            markOwnedPending: false,
          );
          final refreshedCard = (await localSource.getPropertiesList(
            currentUserEmail: currentUserEmail,
          )).where(
            (e) =>
                e.cardId == property.cardId &&
                (e.ownerId ?? '') == (property.ownerId ?? '') &&
                e.isSharedWithMe == property.isSharedWithMe,
          );
          if (refreshedCard.isEmpty) continue;
          final card = refreshedCard.first;
          final spendChanged =
              ((card.monthlyExpenses ?? 0) - beforeSpend).abs() >= 0.009 ||
              ((card.progress ?? 0) - beforeProgress).abs() >= 0.009;
          if (expenseChanged || spendChanged) {
            touched.add(_cardKey(property.cardId, property.ownerId));
          }
        } catch (_) {}
      }

      await expenseLocalSource.removeDuplicateExpenses();

      final refreshed = await localSource.getPropertiesList(
        currentUserEmail: currentUserEmail,
      );
      for (final card in refreshed) {
        if (card.isDeleted) continue;
        if (!touched.contains(_cardKey(card.cardId, card.ownerId))) continue;
        try {
          await remoteSource.updateSpendTotals(
            ownerUid: card.isSharedWithMe
                ? (card.ownerId ?? '')
                : (FirebasePaths.currentUid ?? ''),
            cardId: card.cardId,
            monthlyExpenses: card.monthlyExpenses ?? 0,
            progress: card.progress ?? 0,
          );
        } catch (_) {}
      }
    } catch (_) {}
  }

  String _cardKey(int cardId, String? ownerId) {
    final owner = (ownerId != null && ownerId.isNotEmpty)
        ? ownerId
        : (FirebasePaths.currentUid ?? '');
    return '${cardId}_$owner';
  }

  bool _sameOwnedMeta(PropertyModel local, PropertyModel remote) {
    bool sameNum(num? a, num? b) => ((a ?? 0) - (b ?? 0)).abs() < 0.009;
    return local.propertyName == remote.propertyName &&
        local.propertyLocation == remote.propertyLocation &&
        local.imageUrl == remote.imageUrl &&
        local.categoryType == remote.categoryType &&
        sameNum(local.monthlyBudget, remote.monthlyBudget) &&
        (local.ownerId ?? '') == (remote.ownerId ?? '') &&
        (local.ownerEmail ?? '') == (remote.ownerEmail ?? '');
  }
}
