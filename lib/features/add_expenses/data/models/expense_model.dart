import '../../domain/entitity/add_expense_entity_model.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    super.id,
    super.propertyCardId,
    super.title,
    super.amount,
    super.categoryType,
    super.date,
    super.note,
    super.createAt,
    super.updateAt,
    super.syncStatus,
    super.isDeleted,
  });

  // 🔄 Entity → Model
  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      propertyCardId: entity.propertyCardId,
      title: entity.title,
      amount: entity.amount,
      categoryType: entity.categoryType,
      date: entity.date,
      note: entity.note,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      syncStatus: entity.syncStatus,
      isDeleted: entity.isDeleted,
    );
  }

  // 🔄 Model → Entity
  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      propertyCardId: propertyCardId,
      title: title,
      amount: amount,
      categoryType: categoryType,
      date: date,
      note: note,
      createAt: createAt,
      updateAt: updateAt,
      syncStatus: syncStatus,
      isDeleted: isDeleted,
    );
  }

  // 🗄️ toMap (Sqflite)
  Map<String, dynamic> toMap() {
    return {
      'expenseId': id,
      'propertyCardId': propertyCardId,
      'title': title,
      'amount': amount,
      'categoryType': categoryType,
      'date': date,
      'note': note,
      'createAt': createAt,
      'updateAt': updateAt,
      'syncStatus': syncStatus,
      'isDeleted': isDeleted,
    };
  }

  // 🗄️ fromMap (Sqflite)
  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['expenseId'],
      propertyCardId: map['propertyCardId'],
      title: map['title'],
      amount: (map['amount'] as double?)?.toDouble(),
      categoryType: map['categoryType'],
      date: map['date'],
      note: map['note'],
      createAt: map['createAt'],
      updateAt: map['updateAt'],
      syncStatus: map['syncStatus'],
      isDeleted: map['isDeleted'],
    );
  }

  // 🌐 toJson (API / Firebase)
  Map<String, dynamic> toJson() {
    return {
      'expenseId': id,
      'propertyCardId': propertyCardId,
      'title': title,
      'amount': amount,
      'categoryType': categoryType,
      'date': date,
      'note': note,
      'createAt': createAt,
      'updateAt': updateAt,
      'syncStatus': syncStatus,
      'isDeleted': isDeleted,
    };
  }

  // 🌐 fromJson (API / Firebase)
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['expenseId'],
      propertyCardId: json['propertyCardId'],
      title: json['title'],
      amount: (json['amount'] as double?)?.toDouble(),
      categoryType: json['categoryType'],
      date: json['date'],
      note: json['note'],
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      syncStatus: json['syncStatus'],
      isDeleted: json['isDeleted'],
    );
  }

  // 🔥 copyWith (Model level)
  @override
  ExpenseModel copyWith({
    int? id,
    int? propertyCardId,
    String? title,
    double? amount,
    String? categoryType,
    String? date,
    String? note,
    String? receiptImage,
    String? createAt,
    String? updateAt,
    String? syncStatus,
    int? isDeleted,
  }) {
    return ExpenseModel(
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
