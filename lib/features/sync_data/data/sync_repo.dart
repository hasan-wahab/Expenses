import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/data_source/expense_data_source/expense_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
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

      throw e.toString();
    }
  }

  Future syncExpensesData() async {
    if (!await InternetUtils.hasInternetAccess()) {
      print("No internet connection");
      return;
    }
    try {
      /// Get all expenses from local source
      List<PropertyModel> properties = await localSource.getPropertiesList(
        currentUserEmail: await localSource.getCurrentUserEmail(),
      );
      if (properties.isEmpty) return;
      List<ExpenseModel> expensesList = await expenseLocalSource
          .getAllExpenses();
      if (expensesList.isEmpty) {
        List<ExpenseModel> allRemoteExpenses = [];

        for (var property in properties) {
          expensesList = await expenseRemoteSource.getAllExpenses(
            propertyCardId: property.cardId.toString(),
          );
          allRemoteExpenses.addAll(expensesList);
          print('all Remote data $allRemoteExpenses');
        }
        for (var item in allRemoteExpenses) {
          await expenseLocalSource.addNewExpense(
            model: item.copyWith(syncStatus: SyncStatus.synced.toString()),
            updateMonthlyTotal: false,
          );
        }
      }
      expensesList = await expenseLocalSource.getAllExpenses();
      for (var item in expensesList) {
        if (item.syncStatus == SyncStatus.pending.toString()) {
          await expenseRemoteSource.addNewExpense(
            model: item.copyWith(syncStatus: SyncStatus.synced.toString()),
          );
          expensesList = await expenseLocalSource.getAllExpenses();
        }
      }
    } catch (e) {
      print("Expenses Sync Error: $e");
    }
  }
}
