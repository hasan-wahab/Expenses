import 'dart:convert';

import '../../../../core/constant/enums.dart';
import '../../domain/entitity/dashboard_card_entity.dart';

class PropertyModel extends DashboardCardEntity {
  PropertyModel({
    required super.cardId,
    required super.propertyName,
    required super.imageUrl,
    required super.categoryType,
    required super.createAt,
    super.monthlyBudget = 0.0,
    super.monthlyExpenses = 0.0,
    super.progress = 0.0,
    super.updateAt,
    super.syncStatus,
    super.isDeleted,
    required super.propertyLocation,
  });

  // ✅ COPY WITH (NEW)
  PropertyModel copyWith({
    int? cardId,
    String? propertyName,
    String? imageUrl,
    String? categoryType,
    String? createAt,
    double? monthlyBudget,
    double? monthlyExpenses,
    double? progress,
    String? updateAt,
    String? propertyLocation,
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) {
    return PropertyModel(
      cardId: cardId ?? this.cardId,
      propertyName: propertyName ?? this.propertyName,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryType: categoryType ?? this.categoryType,
      createAt: createAt ?? this.createAt,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      progress: progress ?? this.progress,
      updateAt: updateAt ?? this.updateAt,
      propertyLocation: propertyLocation ?? this.propertyLocation,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  // ✅ TO MAP (DB SAFE)
  Map<String, dynamic> toMap() {
    return {
      'cardId': cardId,
      'propertyName': propertyName,
      'imageUrl': imageUrl,
      'categoryType': categoryType,
      'createAt': createAt,
      'monthlyBudget': monthlyBudget,
      'monthlyExpenses': monthlyExpenses,
      'progress': progress,
      'updateAt': updateAt,
      'propertyLocation': propertyLocation,

      // 🔥 FIXES
      'syncStatus': syncStatus?.name,
      'isDeleted': isDeleted == true ? 1 : 0,
    };
  }

  // ✅ FROM MAP (DB → MODEL)
  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      cardId: map['cardId'],
      propertyName: map['propertyName'],
      imageUrl: map['imageUrl'],
      categoryType: map['categoryType'],
      createAt: map['createAt'],
      monthlyBudget: (map['monthlyBudget'] ?? 0).toDouble(),
      monthlyExpenses: (map['monthlyExpenses'] ?? 0).toDouble(),
      progress: (map['progress'] ?? 0).toDouble(),
      updateAt: map['updateAt'],
      propertyLocation: map['propertyLocation'],

      syncStatus: map['syncStatus'] != null
          ? SyncStatus.values.firstWhere(
              (e) => e.name == map['syncStatus'],
              orElse: () => SyncStatus.pending,
            )
          : SyncStatus.pending,

      isDeleted: (map['isDeleted'] ?? 0) == 1,
    );
  }

  // ✅ JSON
  String toJson() => json.encode(toMap());

  factory PropertyModel.fromJson(String source) =>
      PropertyModel.fromMap(json.decode(source));

  /// 🔹 Model → Entity
  DashboardCardEntity toEntity() {
    return DashboardCardEntity(
      cardId: cardId,
      propertyName: propertyName,
      imageUrl: imageUrl,
      categoryType: categoryType,
      createAt: createAt,
      monthlyBudget: monthlyBudget,
      monthlyExpenses: monthlyExpenses,
      progress: progress,
      updateAt: updateAt,
      propertyLocation: propertyLocation,
      syncStatus: syncStatus,
      isDeleted: isDeleted,
    );
  }

  /// 🔹 Entity → Model
  factory PropertyModel.fromEntity(DashboardCardEntity entity) {
    return PropertyModel(
      cardId: entity.cardId,
      propertyName: entity.propertyName,
      imageUrl: entity.imageUrl,
      categoryType: entity.categoryType,
      createAt: entity.createAt,
      monthlyBudget: entity.monthlyBudget,
      monthlyExpenses: entity.monthlyExpenses,
      progress: entity.progress,
      updateAt: entity.updateAt,
      propertyLocation: entity.propertyLocation,
      syncStatus: entity.syncStatus,
      isDeleted: entity.isDeleted,
    );
  }
}
