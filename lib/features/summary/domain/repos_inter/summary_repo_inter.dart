abstract class SummaryRepoInter {
  Future getSummaryData({
    required int propertyCardId,
    String? propertyOwnerId,
    bool isSharedWithMe,
    double? monthlyBudget,
  });
  Future getAllExpenses({
    required int propertyCardId,
    String? propertyOwnerId,
    bool isSharedWithMe,
  });
}
