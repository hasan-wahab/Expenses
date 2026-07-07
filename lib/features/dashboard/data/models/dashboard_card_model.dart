import 'dart:convert';

import '../../domain/entitity/dashboard_card_entity.dart';

class DashboardCardModel extends DashboardCardEntity {
  DashboardCardModel({
    super.cardId,
    required super.propertyName,
    super.imageUrl,
    required super.categoryType,
    super.createAt,
    required super.monthlyBudget,
    required super.monthlyExpenses,
    required super.progress,
    super.updateAt,
    required super.propertyLocation,
  });

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
    };
  }

  factory DashboardCardModel.fromMap(Map<String, dynamic> map) {
    return DashboardCardModel(
      cardId: map['cardId'],
      propertyName: map['propertyName'],
      imageUrl: map['imageUrl'],
      categoryType: map['categoryType'],
      createAt: map['createAt'],
      monthlyBudget: map['monthlyBudget'],
      monthlyExpenses: map['monthlyExpenses'],
      progress: map['progress'],
      updateAt: map['updateAt'],
      propertyLocation: map['propertyLocation'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardCardModel.fromJson(String source) =>
      DashboardCardModel.fromMap(json.decode(source));

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
    );
  }

  /// 🔹 Entity → Model
  factory DashboardCardModel.fromEntity(DashboardCardEntity entity) {
    return DashboardCardModel(
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
    );
  }
}
