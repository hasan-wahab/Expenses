class SummaryEvents {}

class OnGetSummaryDataEvent extends SummaryEvents {
  final int propertyCardId;
  OnGetSummaryDataEvent({required this.propertyCardId});
}

class OnGetAllExpensesEvent extends SummaryEvents {
  final int propertyCardId;
  OnGetAllExpensesEvent({required this.propertyCardId});
}
