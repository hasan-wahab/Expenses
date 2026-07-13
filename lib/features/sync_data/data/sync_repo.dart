import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/app_key/table_keys.dart';
import 'package:expense_app/core/data_source/properties_data_source/properties_remote_source.dart';
import 'package:expense_app/core/data_source/properties_data_source/propertis_local_source.dart';
import 'package:expense_app/core/storage/sqflite_curd.dart';
import 'package:expense_app/core/utils/internet_utils.dart';

import '../../../core/constant/enums.dart';
import '../../dashboard/data/models/property_card_model.dart';

class SyncRepo {
  final PropertiesRemoteSource remoteSource;
  final PropertiesLocalSource localSource;

  SyncRepo({required this.remoteSource, required this.localSource});

  Future syncData() async {
    if (!await InternetUtils.hasInternetAccess()) {
      print("No internet connection");
      return;
    }

    try {
      String currentUserEmail = await localSource.getCurrentUserEmail();
      print(currentUserEmail);
      List<PropertyModel> list = await localSource.getPropertiesList(
        currentUserEmail: currentUserEmail,
      );
      print("Lis of local source $list");
      if (list.isEmpty) {
        final remoteList = await remoteSource.getPropertiesList(
          currentUserEmail: currentUserEmail,
        );
        print('Remote list: $remoteList');
        for (var item in remoteList) {
          final model = PropertyModel.fromEntity(item);
          print('Adding new property: $model');
          await localSource.addNewProperty(
            model: model,
            currentUserEmail: currentUserEmail,
          );
          list = await localSource.getPropertiesList(
            currentUserEmail: currentUserEmail,
          );
          print('Updated local list: $list');
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
      print("Sync Error: $e");
    }
  }
}
