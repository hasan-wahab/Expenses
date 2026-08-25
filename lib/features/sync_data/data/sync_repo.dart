import 'dart:async';

import 'package:expense_app/core/data_source/expense_data_source/expense_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/add_expenses/data/models/expense_model.dart';

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

  Future syncPropertiesData() async {
    if (!await InternetUtils.hasInternetAccess()) {
      print("No internet connection");
      return;
    }

    try {
      String currentUserEmail = await localSource.getCurrentUserEmail();
      List<PropertyModel> list = await localSource.getPropertiesList(
        currentUserEmail: currentUserEmail,
      );
      if (list.isEmpty) {
        final remoteList = await remoteSource.getPropertiesList(
          currentUserEmail: currentUserEmail,
        );
        for (var item in remoteList) {
          print('Adding new property: ${PropertyModel.fromEntity(item)}');
          await localSource.addNewProperty(
            model: PropertyModel.fromEntity(
              item.copyWith(syncStatus: SyncStatus.synced),
            ),
            currentUserEmail: currentUserEmail,
          );
          list = await localSource.getPropertiesList(
            currentUserEmail: currentUserEmail,
          );
        }
      } else {
        for (var item in list) {
          if (item.isSharedWithMe) continue;
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
        }
      }
    } catch (e) {
      print("Properties Sync Error: $e");
    }
  }

  Future syncExpensesData() async {
    if (!await InternetUtils.hasInternetAccess()) {
      print("No internet connection");
      return;
    }
    try {
      final currentUserEmail = await localSource.getCurrentUserEmail();
      var expensesList = await expenseLocalSource.getAllExpenses();

      for (final item in expensesList) {
        if (item.syncStatus != SyncStatus.pending.toString()) continue;

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
      }

      List<PropertyModel> ownedProperties =
          (await localSource.getPropertiesList(
            currentUserEmail: currentUserEmail,
          )).where((e) => !e.isSharedWithMe).toList();
      if (ownedProperties.isEmpty) return;

      final ownedLocal = (await expenseLocalSource.getAllExpenses())
          .where((e) => !e.isSharedWithMe)
          .toList();
      if (ownedLocal.isEmpty) {
        List<ExpenseModel> allRemoteExpenses = [];
        for (var property in ownedProperties) {
          expensesList = await expenseRemoteSource.getAllExpenses(
            propertyCardId: property.cardId.toString(),
          );
          allRemoteExpenses.addAll(expensesList);
        }
        for (var item in allRemoteExpenses) {
          await expenseLocalSource.addNewExpense(
            model: item.copyWith(
              syncStatus: SyncStatus.synced.toString(),
              propertyOwnerId: '',
              isSharedWithMe: false,
            ),
            updateMonthlyTotal: false,
          );
        }
      }
    } catch (e) {
      print("Expenses Sync Error: $e");
    }
  }
}
