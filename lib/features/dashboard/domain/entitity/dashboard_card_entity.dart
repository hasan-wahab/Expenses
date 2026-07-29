import 'dart:io';

import 'package:expense_app/core/constant/enums.dart';

class DashboardCardEntity {
  final int cardId;
  final String propertyName;
  final String propertyLocation;
  final double? monthlyExpenses;
  final double monthlyBudget;
  final double? progress;
  final String imageUrl;
  final String createAt;
  final String? updateAt;
  final String categoryType;
  final SyncStatus? syncStatus;
  final bool isDeleted;

  DashboardCardEntity({
    required this.cardId,
    required this.propertyName,
    required this.propertyLocation,
    this.monthlyExpenses = 0.0,
    this.monthlyBudget = 0.0,
    required this.categoryType,
    this.progress = 0.0,
    required this.imageUrl,
    required this.createAt,
    this.updateAt,
    this.syncStatus = SyncStatus.pending,
    this.isDeleted = false,
  });

  DashboardCardEntity copyWith({
    int? cardId,
    String? propertyName,
    String? propertyLocation,
    double? monthlyExpenses,
    double? monthlyBudget,
    double? progress,
    String? imageUrl,
    String? createAt,
    String? updateAt,
    String? categoryType,
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) {
    return DashboardCardEntity(
      cardId: cardId ?? this.cardId,
      propertyName: propertyName ?? this.propertyName,
      propertyLocation: propertyLocation ?? this.propertyLocation,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      progress: progress ?? this.progress,
      imageUrl: imageUrl ?? this.imageUrl,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      categoryType: categoryType ?? this.categoryType,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
