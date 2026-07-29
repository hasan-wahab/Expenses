import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_app/core/constant/enums.dart';
import 'package:expense_app/features/auth/domain/entitity/auth_entity.dart';

class UserModel extends AuthEntity {
  final int? id;
  final String? createAt;
  final String? updateAt;

  UserModel({
    this.id,
    super.name,
    super.email,
    super.password,
    super.loginWith,
    this.createAt,
    this.updateAt,
    super.phone,
    super.imageUrl,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? loginWith,
    String? createAt,
    String? updateAt,
    String? phone,
    String? imageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      loginWith: LoginType.emailAndPassword,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'loginWith': loginWith.toString(),
      'createAt': createAt,
      'updateAt': updateAt,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }

  // Create object from Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createAt: map['createAt'],
      updateAt: map['updateAt'],
      loginWith: map['loginWith'] == 'emailAndPassword'
          ? LoginType.emailAndPassword
          : LoginType.google,
      phone: map['phone'],
      imageUrl: map['imageUrl'],
    );
  }

  /// 🔹 Entity → Model
  factory UserModel.fromEntity(AuthEntity entity) {
    return UserModel(
      name: entity.name,
      email: entity.email,
      password: entity.password,
      loginWith: entity.loginWith,
      createAt: DateTime.now().toIso8601String(),
      imageUrl: entity.imageUrl,
      phone: entity.phone,
    );
  }

  /// 🔹 Model → Entity
  AuthEntity toEntity() {
    return AuthEntity(
      name: name,
      email: email,
      password: password,
      loginWith: loginWith,
      phone: phone,
      imageUrl: imageUrl,
    );
  }

  // Convert object to JSON
  String toJson() => json.encode(toMap());

  // Create object from JSON
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
