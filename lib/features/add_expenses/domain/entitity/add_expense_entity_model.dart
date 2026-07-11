class AddExpenseEntityModel {
  final String expenseId;
  final String expenseCategory;
  final String expenseAmount;
  final String? note;
  final String? receiptImage;
  final String date;
  final String propertyId;

  AddExpenseEntityModel({
    required this.expenseId,
    required this.expenseCategory,
    required this.expenseAmount,
    this.note,
    this.receiptImage,
    required this.date,
    required this.propertyId,
  });

  /// Convert Entity To Map
  Map<String, dynamic> toMap() {
    return {
      'expenseId': expenseId,
      'expenseCategory': expenseCategory,
      'expenseAmount': expenseAmount,
      'note': note,
      'receiptImage': receiptImage,
      'date': date,
      'propertyId': propertyId,
    };
  }

  /// From Map To Entity
  factory AddExpenseEntityModel.fromMap(Map<String, dynamic> map) {
    return AddExpenseEntityModel(
      expenseId: map['expenseId'],
      expenseCategory: map['expenseCategory'],
      expenseAmount: map['expenseAmount'],
      note: map['note'],
      receiptImage: map['receiptImage'],
      date: map['date'],
      propertyId: map['propertyId'],
    );
  }
}
