class DashboardCardEntity {
  final int? cardId;
  final String? propertyName;
  final String? propertyLocation;
  final double? monthlyExpenses;
  final double? monthlyBudget;
  final double? progress;
  final String? imageUrl;
  final String? createAt;
  final String? updateAt;
  final String? categoryType;
  DashboardCardEntity({
    this.cardId,
    this.propertyName,
    this.propertyLocation,
    this.monthlyExpenses,
    this.monthlyBudget,
    this.categoryType,
    this.progress,
    this.imageUrl,
    this.createAt,
    this.updateAt,
  });
}
