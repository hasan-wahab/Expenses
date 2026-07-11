import 'dart:developer';

import 'package:expense_app/core/utils/internet_utils.dart';
import 'package:expense_app/features/dashboard/data/local.dart';
import 'package:expense_app/features/dashboard/data/models/dashboard_card_model.dart';
import 'package:expense_app/features/dashboard/domain/entitity/dashboard_card_entity.dart';
import 'package:expense_app/features/dashboard/domain/repos_inter/dashboard_repo_inter.dart';

class DashboardUseCase {
  final DashboardRepoInter dashboardRepoInter;
  final DashboardLocal local;

  DashboardUseCase({required this.dashboardRepoInter, required this.local});

  // /// Save Property
  // Future saveProperty({required DashboardCardEntity model}) async {
  //   /// Check Internet Connection
  //   if (await InternetUtils.isInternetAvailable()) {
  //     /// Save Property in Firebase
  //     await dashboardRepoInter.save(
  //       model: DashboardCardModel.fromEntity(model),
  //     );
  //
  //     /// Save Property in Local Storage
  //     await local.addNewPropertyCard(
  //       model: DashboardCardModel.fromEntity(model),
  //     );
  //   } else {
  //     /// Save Property in Local Storage => if no internet connection
  //     await local.addNewPropertyCard(
  //       model: DashboardCardModel.fromEntity(model),
  //     );
  //   }
  // }

  /// Get Property
  Future<List<DashboardCardEntity>> getPropertyList() async {
    List<DashboardCardModel> list = [];

    /// Check Internet Connection
    if (await InternetUtils.isInternetAvailable()) {
      /// Get Property From Firebase
      list = await dashboardRepoInter.get();
      if (list.isEmpty) {
        /// Get Property in Local Storage => if No Internet Connection
        list = await local.getPropertyList();
      }

      /// Convert Model To Entity
      return list.map((e) => e.toEntity()).toList();
    } else {
      /// Get Property From Local Storage => if No Data In Firebase
      list = await local.getPropertyList();

      /// Convert Model To Entity
      return list.map((e) => e.toEntity()).toList();
    }
  }

  Future syncData() async {
    /// Get Property From Local Storage
    List<DashboardCardModel> list = await local.getPropertyList();
    if (list.isNotEmpty) {
      /// Save Property in Firebase
      if (await InternetUtils.isInternetAvailable()) {
        for (var element in list) {
          await dashboardRepoInter.save(model: element);
        }
      }
    } else {
      /// Get Property From Firebase
      if (await InternetUtils.isInternetAvailable()) {
        list = await dashboardRepoInter.get();
        if (list.isNotEmpty) {
          /// Save Property in Local Storage
          for (var element in list) {
            await local.addNewPropertyCard(model: element);
          }
        }
      }
    }
    log('From Sync Data');
  }
}
