import 'dart:io';

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
  });
}
