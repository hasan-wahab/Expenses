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

  /// Save Property
  Future saveProperty({required DashboardCardEntity model}) async {
    if (await InternetUtils.isInternetAvailable()) {
      await dashboardRepoInter.save(
        model: DashboardCardModel.fromEntity(model),
      );

      await local.addNewPropertyCard(
        model: DashboardCardModel.fromEntity(model),
      );
    } else {
      await local.addNewPropertyCard(
        model: DashboardCardModel.fromEntity(model),
      );
    }
  }

  /// Get Property
  Future<List<DashboardCardEntity>> getPropertyList() async {
    List<DashboardCardModel> list = [];
    if (await InternetUtils.isInternetAvailable()) {
      list = await dashboardRepoInter.get();
      if (list.isEmpty) {
        list = await local.getPropertyList();
      }
      return list.map((e) => e.toEntity()).toList();
    } else {
      list = await local.getPropertyList();
      return list.map((e) => e.toEntity()).toList();
    }
  }

  Future syncData() async {
    List<DashboardCardModel> list = await local.getPropertyList();
    if (list.isNotEmpty) {
      for (var element in list) {
        await dashboardRepoInter.save(model: element);
      }
    }
  }
}
