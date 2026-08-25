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
    super.ownerId,
    super.ownerEmail,
    super.isSharedWithMe = false,
    super.myPermissions = const [],
  });

  @override
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
    String? ownerId,
    String? ownerEmail,
    bool? isSharedWithMe,
    List<String>? myPermissions,
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
      ownerId: ownerId ?? this.ownerId,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      isSharedWithMe: isSharedWithMe ?? this.isSharedWithMe,
      myPermissions: myPermissions ?? this.myPermissions,
    );
  }

  /// Local map including share fields (SQLite).
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
      'syncStatus': syncStatus?.name,
      'isDeleted': isDeleted == true ? 1 : 0,
      'ownerId': ownerId ?? '',
      'ownerEmail': ownerEmail ?? '',
      'isSharedWithMe': isSharedWithMe ? 1 : 0,
      'myPermissions': myPermissions.join(','),
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map) {
    return PropertyModel(
      cardId: _readInt(map['cardId']),
      propertyName: (map['propertyName'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      categoryType: (map['categoryType'] ?? '').toString(),
      createAt: (map['createAt'] ?? '').toString(),
      monthlyBudget: (map['monthlyBudget'] ?? 0).toDouble(),
      monthlyExpenses: (map['monthlyExpenses'] ?? 0).toDouble(),
      progress: (map['progress'] ?? 0).toDouble(),
      updateAt: map['updateAt']?.toString(),
      propertyLocation: (map['propertyLocation'] ?? '').toString(),
      syncStatus: map['syncStatus'] != null
          ? SyncStatus.values.firstWhere(
              (e) => e.name == map['syncStatus'],
              orElse: () => SyncStatus.pending,
            )
          : SyncStatus.pending,
      isDeleted: _readBool(map['isDeleted']),
      ownerId: (map['ownerId']?.toString() ?? '').isEmpty
          ? null
          : map['ownerId']?.toString(),
      ownerEmail: (map['ownerEmail']?.toString() ?? '').isEmpty
          ? null
          : map['ownerEmail']?.toString(),
      isSharedWithMe: _readBool(map['isSharedWithMe']),
      myPermissions: _readPermissions(map['myPermissions']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyModel.fromJson(String source) =>
      PropertyModel.fromMap(json.decode(source));

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
      ownerId: ownerId,
      ownerEmail: ownerEmail,
      isSharedWithMe: isSharedWithMe,
      myPermissions: myPermissions,
    );
  }

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
      ownerId: entity.ownerId,
      ownerEmail: entity.ownerEmail,
      isSharedWithMe: entity.isSharedWithMe,
      myPermissions: entity.myPermissions,
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  static bool _readBool(dynamic value) {
    return value == true || value == 1 || value == '1';
  }

  static List<String> _readPermissions(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }
    final text = value?.toString() ?? '';
    if (text.isEmpty) return const [];
    return text.split(',').where((e) => e.trim().isNotEmpty).toList();
  }
}
