class SummaryEvents {}

class OnGetSummaryDataEvent extends SummaryEvents {
  final int propertyCardId;
  final String? propertyOwnerId;
  final bool isSharedWithMe;
  final double? monthlyBudget;

  OnGetSummaryDataEvent({
    required this.propertyCardId,
    this.propertyOwnerId,
    this.isSharedWithMe = false,
    this.monthlyBudget,
  });
}

class OnGetAllExpensesEvent extends SummaryEvents {
  final int propertyCardId;
  final String? propertyOwnerId;
  final bool isSharedWithMe;

  OnGetAllExpensesEvent({
    required this.propertyCardId,
    this.propertyOwnerId,
    this.isSharedWithMe = false,
  });
}
