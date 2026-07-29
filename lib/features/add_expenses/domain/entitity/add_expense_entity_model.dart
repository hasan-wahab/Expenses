class ExpenseEntity {
  final int? id;
  final int? propertyCardId;

  final String? title;
  final double? amount;
  final String? categoryType;

  final String? date;
  final String? note;

  final String? createAt;
  final String? updateAt;

  final String? syncStatus;
  final int? isDeleted;

  const ExpenseEntity({
    this.id,
    this.propertyCardId,
    this.title,
    this.amount,
    this.categoryType,
    this.date,
    this.note,
    this.createAt,
    this.updateAt,
    this.syncStatus,
    this.isDeleted,
  });

  // 🔥 copyWith
  ExpenseEntity copyWith({
    int? id,
    int? propertyCardId,
    String? title,
    double? amount,
    String? categoryType,
    String? date,
    String? note,
    String? createAt,
    String? updateAt,
    String? syncStatus,
    int? isDeleted,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      propertyCardId: propertyCardId ?? this.propertyCardId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryType: categoryType ?? this.categoryType,
      date: date ?? this.date,
      note: note ?? this.note,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
